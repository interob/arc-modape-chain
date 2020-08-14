"""test_cli.py: Test command line scripts."""
#pylint: disable=E0401
from datetime import date
from pathlib import Path
import shutil
import unittest
from unittest.mock import patch, Mock, MagicMock, call
from click.testing import CliRunner

from modape.scripts.modis_download import cli as modis_download_cli
from modape.scripts.modis_collect import cli as modis_collect_cli
from modape.scripts.modis_smooth import cli as modis_smooth_cli
from modape.scripts.modis_window import cli as modis_window_cli
import numpy as np

from test_modis import create_h5temp

class TestConsoleScripts(unittest.TestCase):
    """Test class for console scripts."""

    @classmethod
    def setUpClass(cls):
        '''Set up testing class'''

        cls.testpath = Path('/tmp')

        cls.lst_files = ['MYD11A2.A2002193.h18v06.006.2015146152945.hdf',
                         'MOD11A2.A2002209.h18v06.006.2015145152020.hdf',
                         'MYD11A2.A2002201.h18v06.006.2015146153241.hdf',
                         'MYD11A2.A2002185.h18v06.006.2015146152642.hdf',
                         'MOD11A2.A2002177.h18v06.006.2015144183717.hdf',
                         'MYD11A2.A2002209.h18v06.006.2015152152813.hdf',
                         'MOD11A2.A2002185.h18v06.006.2015145002847.hdf',
                         'MOD11A2.A2002193.h18v06.006.2015145055806.hdf',
                         'MOD11A2.A2002201.h18v06.006.2015145105749.hdf']

        cls.vim_files = ['MYD13A2.A2002201.h18v06.006.2015149071105.hdf',
                         'MYD13A2.A2002185.h18v06.006.2015149071113.hdf',
                         'MOD13A2.A2002177.h18v06.006.2015149001129.hdf',
                         'MOD13A2.A2002209.h18v06.006.2015149180726.hdf',
                         'MOD13A2.A2002193.h18v06.006.2015149022847.hdf']

    @classmethod
    def tearDownClass(cls):
        try:
            shutil.rmtree('__pycache__')
        except: #pylint: disable=W0702
            pass

        try:
            shutil.rmtree('/tmp/data')
        except: #pylint: disable=W0702
            pass

    def setUp(self):
        """Set up a test"""
        self.runner = CliRunner()

    def test_modis_download(self):
        """Test modis_download.py."""

        test_query = MagicMock()
        test_query.nresults = 4
        test_query.download = Mock(return_value='Mocking download!')

        with patch('modape.scripts.modis_download.ModisQuery', return_value=test_query) as mocked_query:

            result = self.runner.invoke(modis_download_cli, ["MOD13A2"])

            mocked_query.assert_called()
            args = mocked_query.call_args_list[0][1]
            self.assertEqual(args['products'], ["MOD13A2"])
            assert result.exit_code == 0

            mocked_query.reset_mock()
            #
            result = self.runner.invoke(modis_download_cli, ["m?d13a2"])
            mocked_query.assert_called()
            args = mocked_query.call_args_list[0][1]
            self.assertEqual(args['products'], ["MOD13A2", 'MYD13A2'])
            assert result.exit_code == 0

            mocked_query.reset_mock()

            result = self.runner.invoke(modis_download_cli, ["MOD13A2", "--download"])
            mocked_query.assert_not_called()
            assert result.exit_code == 1

            result = self.runner.invoke(modis_download_cli, ["MOD13A2", "--username", "test", "--password", "test", "--download"])
            mocked_query.assert_called()

            mocked_query.reset_mock()

            fake_hdf = self.testpath.joinpath("MOD13A2.A2002193.h18v06.006.2019256103823.hdf")
            fake_hdf.touch()

            result = self.runner.invoke(modis_download_cli, ["MOD13A2", "--targetdir", str(self.testpath)])
            mocked_query.assert_called()
            assert result.exit_code == 0

            mocked_query.reset_mock()

            result = self.runner.invoke(modis_download_cli, ["MOD13A2", "--targetdir", str(self.testpath), "--target-empty"])
            mocked_query.assert_not_called()

            assert result.exit_code == 1

            fake_hdf.unlink()

            result = self.runner.invoke(modis_download_cli, ["MOD13A2", "--targetdir", str(self.testpath), "--target-empty"])
            mocked_query.assert_called()

            assert result.exit_code == 0

            mocked_query.reset_mock()

            result = self.runner.invoke(modis_download_cli, ["MOD13A2", "--roi", "10,10"])
            mocked_query.assert_called()
            args = mocked_query.call_args_list[0][1]
            self.assertEqual(args['aoi'], (10.0, 10.0))
            assert result.exit_code == 0

            mocked_query.reset_mock()

            result = self.runner.invoke(modis_download_cli, ["MOD13A2", "--roi", "10,10,20,20"])
            mocked_query.assert_called()
            args = mocked_query.call_args_list[0][1]
            self.assertEqual(args['aoi'], (10.0, 10.0, 20.0, 20.0))
            assert result.exit_code == 0

            mocked_query.reset_mock()

            result = self.runner.invoke(modis_download_cli, ["MOD13A2", "--roi", "10,20,20"])
            mocked_query.assert_not_called()
            assert result.exit_code == 1

            mocked_query.reset_mock()

            result = self.runner.invoke(modis_download_cli, ["MOD13A2", "--roi", "10,20,20,30,50"])
            mocked_query.assert_not_called()
            assert result.exit_code == 1

    def test_modis_collect(self):
        """Test modis_collect.py"""
        result = self.runner.invoke(modis_collect_cli, ["/not_an_exist_dir"])
        self.assertEqual(result.exit_code, 1)

        testfile = Path('/tmp/file.txt')
        testfile.touch()
        result = self.runner.invoke(modis_collect_cli, [str(testfile)])
        self.assertEqual(result.exit_code, 1)
        testfile.unlink()

        result = self.runner.invoke(modis_collect_cli, ["/tmp"])
        self.assertEqual(result.exit_code, 1)

        data_dir = self.testpath.joinpath('data')
        data_dir.mkdir()

        for file in self.lst_files:
            file_path = data_dir.joinpath(file)
            file_path.touch()

        calls = []
        for product in ['MOD11', 'MYD11']:
            product_files = [str(x) for x in data_dir.glob("*hdf") if product in x.name]
            product_files.sort()
            calls.append(
                call(product_files, data_dir, None, False, "gzip", None),
            )

        with patch("modape.scripts.modis_collect._worker") as mocked_worker:
            mocked_worker.return_value = True
            result = self.runner.invoke(modis_collect_cli, ["/tmp/data"])
            mocked_worker.assert_called()
            self.assertEqual(mocked_worker.call_count, 2)
            mocked_worker.assert_has_calls(calls, any_order=False)

        _ = [x.unlink() for x in data_dir.glob("*hdf")]

        for file in self.vim_files:
            file_path = data_dir.joinpath(file)
            file_path.touch()

        with patch("modape.scripts.modis_collect._worker") as mocked_worker:
            mocked_worker.return_value = True
            product_files = [str(x) for x in data_dir.glob("*hdf")]
            result = self.runner.invoke(modis_collect_cli, ["/tmp/data", "--interleave", "--cleanup"])
            mocked_worker.assert_called_once()
            product_files.sort()
            mocked_worker.assert_called_with(product_files, data_dir, None, True, "gzip", None)

        tracefile = data_dir.joinpath('.collected')
        self.assertTrue(tracefile.exists())
        self.assertTrue(not any([Path(x).exists() for x in product_files]))
        with open(str(tracefile), 'r') as thefile:
            collected = [x.strip() for x in thefile.readlines()]
        self.assertEqual(collected, [x.split('/')[-1] for x in product_files])

        for file in self.vim_files:
            file_path = data_dir.joinpath(file)
            file_path.touch()

        with patch("modape.scripts.modis_collect._worker") as mocked_worker:
            mocked_worker.return_value = True
            product_files = [str(x) for x in data_dir.glob("*hdf")]
            product_files.sort()
            result = self.runner.invoke(modis_collect_cli, ["/tmp/data", "--interleave", "--cleanup", "--last-collected", "2002-01-01"])
            mocked_worker.assert_not_called()
            self.assertEqual(result.exit_code, 2)

        with patch("modape.scripts.modis_collect.ModisRawH5") as mocked_rawfile:
            mocked_rawfile.return_value = MagicMock(exists=True, last_collected="2020001")
            result = self.runner.invoke(modis_collect_cli, ["/tmp/data", "--interleave", "--cleanup", "--last-collected", "2020365"])
            mocked_rawfile.assert_called_once()
            self.assertEqual(result.exit_code, 1)

            mocked_rawfile.reset_mock()
            result = self.runner.invoke(modis_collect_cli, ["/tmp/data", "--interleave", "--cleanup", "--last-collected", "2020001"])
            mocked_rawfile.assert_called_once()
            self.assertEqual(result.exit_code, 0)

    def test_modis_smooth(self):
        """Test modis_smooth.py"""

        result = self.runner.invoke(modis_smooth_cli, ["/not_an_exist_dir"])
        self.assertEqual(result.exit_code, 1)

        result = self.runner.invoke(modis_smooth_cli, ["/tmp"])
        self.assertEqual(result.exit_code, 1)

        raw_h5 = create_h5temp(10, 10, 8, 8)

        with patch("modape.scripts.modis_smooth._worker", return_value=True) as mocked_worker:

            result = self.runner.invoke(modis_smooth_cli,
                                        [str(raw_h5),
                                         "--targetdir",
                                         str(raw_h5)])

            mocked_worker.assert_not_called()
            self.assertEqual(result.exit_code, 1)

            result = self.runner.invoke(modis_smooth_cli,
                                        [str(raw_h5),
                                         "--nsmooth", 1,
                                         "--nupdate", 10])

            mocked_worker.assert_not_called()
            self.assertEqual(result.exit_code, 1)

            result = self.runner.invoke(modis_smooth_cli,
                                        [str(raw_h5),
                                         "--srange", 0, 1])


            mocked_worker.assert_not_called()
            self.assertEqual(result.exit_code, 2)

            result = self.runner.invoke(modis_smooth_cli,
                                        [str(raw_h5),
                                         "--srange", 0, 1, 0.2])


            mocked_worker.assert_called()
            self.assertEqual(result.exit_code, 0)


        with patch("modape.scripts.modis_smooth._worker", return_value=False) as mocked_worker:
            result = self.runner.invoke(modis_smooth_cli, [str(raw_h5)])
            mocked_worker.assert_called()
            self.assertEqual(result.exit_code, 1)

            mocked_worker.reset_mock()
            mocked_worker.return_value = True

            result = self.runner.invoke(modis_smooth_cli, [str(raw_h5)])
            mocked_worker.assert_called()
            self.assertEqual(result.exit_code, 0)

        with patch("modape.scripts.modis_smooth._worker", return_value=True) as mocked_worker:

            result = self.runner.invoke(
                modis_smooth_cli,
                [str(raw_h5),
                 "--targetdir", "/tmp",
                 "--svalue", 1.0,
                 "--srange", 0, 1, 0.2,
                 "--pvalue", 0.90,
                 "--tempint", 10,
                 "--tempint-start", "2001001",
                 "--nsmooth", 10,
                 "--nupdate", 10,
                 "--voptimize",
                 "--last-collected", "2002001",
                ])

            mocked_worker.assert_called_once()
            margs, mkwargs = mocked_worker.call_args

            self.assertEqual(margs[0], str(raw_h5))
            self.assertEqual(margs[1], Path('/tmp'))
            self.assertEqual(margs[2], 10)
            self.assertEqual(margs[3], "2001001")
            self.assertEqual(margs[4], "2002001")

            self.assertEqual(mkwargs["svalue"], 1.0)
            np.testing.assert_array_equal(mkwargs["srange"], np.arange(0, 1.2, 0.2).round(2))
            self.assertEqual(mkwargs["p"], 0.90)
            self.assertEqual(mkwargs["nsmooth"], 10)
            self.assertEqual(mkwargs["nupdate"], 10)
            self.assertTrue(mkwargs["voptimize"])

            self.assertEqual(result.exit_code, 0)

        with patch("modape.scripts.modis_smooth.ModisSmoothH5") as mocked_smoothfile:
            mocked_smoothfile.return_value = MagicMock(exists=False)
            result = self.runner.invoke(modis_smooth_cli, [str(raw_h5)])
            mocked_smoothfile.assert_called_once()
            self.assertEqual(result.exit_code, 1)

            mocked_smoothfile.reset_mock()
            mocked_smoothfile.return_value = MagicMock(exists=True, last_collected="2020001")
            result = self.runner.invoke(modis_smooth_cli, [str(raw_h5), "--last-collected", "2020002"])
            mocked_smoothfile.assert_called_once()
            self.assertEqual(result.exit_code, 1)

            mocked_smoothfile.reset_mock()
            mocked_smoothfile.return_value = MagicMock(exists=True, last_collected="2020001")
            result = self.runner.invoke(modis_smooth_cli, [str(raw_h5), "--last-collected", "2020001"])
            mocked_smoothfile.assert_called_once()
            self.assertEqual(result.exit_code, 0)

        raw_h5.unlink()

    @patch("modape.scripts.modis_window.ModisMosaic.generate_mosaics")
    def test_modis_window(self, mocked_mosaic):
        """Test modis_window.py"""

        raw_h5 = create_h5temp(10, 10, 8, 8)

        result = self.runner.invoke(modis_window_cli, ["/not_an_exist_dir"])
        self.assertEqual(result.exit_code, 1)

        result = self.runner.invoke(modis_window_cli, ["/tmp/data", "--roi", "10,20"])
        print(result.output)
        self.assertEqual(result.exit_code, 1)

        result = self.runner.invoke(modis_window_cli, [str(raw_h5)])
        self.assertEqual(result.exit_code, 0)
        mocked_mosaic.assert_called_once()

        mocked_mosaic.reset_mock()

        result = self.runner.invoke(modis_window_cli, ["/tmp/data"])
        self.assertEqual(result.exit_code, 0)
        mocked_mosaic.assert_called_once()
        _, mkwargs = mocked_mosaic.call_args

        self.assertEqual(mkwargs["dataset"], "data")
        self.assertEqual(mkwargs["targetdir"], Path("/tmp/data"))
        self.assertEqual(mkwargs["target_srs"], "EPSG:4326")
        self.assertEqual(mkwargs["aoi"], None)
        self.assertEqual(mkwargs["overwrite"], False)
        self.assertEqual(mkwargs["force_doy"], False)
        self.assertEqual(mkwargs["prefix"], "reg")
        self.assertEqual(mkwargs["start"], None)
        self.assertEqual(mkwargs["stop"], None)
        self.assertEqual(mkwargs["clip_valid"], False)
        self.assertEqual(mkwargs["round_int"], None)
        self.assertEqual(mkwargs["creationOptions"], ["COMPRESS=LZW", "PREDICTOR=2"])

        mocked_mosaic.reset_mock()

        result = self.runner.invoke(
            modis_window_cli,
            ["/tmp/data",
             "-b", "2020-01-01",
             "-e", "2020-05-01",
             "--roi", "0,0,10,10",
             "--sgrid",
             "--co", "COMPRESS=DEFLATE",
             "--co", "PREDICTOR=1",
             "--co", "TILED=YES",
             "--target-srs", "EPSG:3857",
             "--round-int", 2,
             "--clip-valid"]
        )
        self.assertEqual(result.exit_code, 0)
        mocked_mosaic.assert_called_once()
        _, mkwargs = mocked_mosaic.call_args
        self.assertEqual(mkwargs["dataset"], "sgrid")
        self.assertEqual(mkwargs["target_srs"], "EPSG:3857")
        self.assertEqual(mkwargs["start"], date(2020, 1, 1))
        self.assertEqual(mkwargs["stop"], date(2020, 5, 1))
        self.assertEqual(mkwargs["aoi"], [0, 0, 10, 10])
        self.assertEqual(mkwargs["creationOptions"], ["COMPRESS=DEFLATE", "PREDICTOR=1", "TILED=YES"])
        self.assertEqual(mkwargs["clip_valid"], False)
        self.assertEqual(mkwargs["round_int"], -2)

        mocked_mosaic.reset_mock()

        result = self.runner.invoke(
            modis_window_cli,
            ["/tmp/data",
             "--gdal-kwarg", "xRes=10",
             "--gdal-kwarg", "yRes=10",
             "--gdal-kwarg", "outputType=1",
             "--gdal-kwarg", "resampleAlg=bilinear",
             "--gdal-kwarg", "noData=0"]
        )
        self.assertEqual(result.exit_code, 0)
        mocked_mosaic.assert_called_once()
        _, mkwargs = mocked_mosaic.call_args
        self.assertEqual(mkwargs["xRes"], "10")
        self.assertEqual(mkwargs["yRes"], "10")
        self.assertEqual(mkwargs["outputType"], "1")
        self.assertEqual(mkwargs["noData"], "0")
        self.assertEqual(mkwargs["resampleAlg"], "bilinear")

        mocked_mosaic.reset_mock()

        with patch("modape.scripts.modis_window.ModisMosaic.__init__", return_value=None) as mock_init:
            src = self.testpath.joinpath("data")
            src.joinpath("MXD13A2.h21v10.006.VEM.h5").touch()
            result = self.runner.invoke(modis_window_cli, ["/tmp/data"])
            self.assertEqual(result.exit_code, 0)
            mock_init.assert_called()
            self.assertEqual(mock_init.call_count, 2)
            mocked_mosaic.assert_called()
            self.assertEqual(mocked_mosaic.call_count, 2)

        mocked_mosaic.reset_mock()
        src.joinpath("MYD11A2.h21v10.006.TDA.h5").touch()

        with patch("modape.scripts.modis_window.ModisMosaic.__init__", return_value=None) as mock_init:
            src = self.testpath.joinpath("data")
            src.joinpath("MXD13A2.h21v10.006.VEM.h5").touch()
            result = self.runner.invoke(modis_window_cli, ["/tmp/data"])
            self.assertEqual(result.exit_code, 1)
            mock_init.assert_not_called()
            mocked_mosaic.assert_not_called()
