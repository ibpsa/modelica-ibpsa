#!/usr/bin/env python3

"""Import the SDF Library into IBPSA.

This script downloads a specified version of the SDF library from GitHub,
integrates it into IBPSA as a new package, and optionally runs a validation test.

Usage:
    python /path/to/importSDF.py VERSION [--test]

Arguments:
    VERSION: SDF Library version
    --test: Optional flag to run a validation test

Example:
    python /path/to/importSDF.py 0.4.4
"""

import argparse
import os
import re
import shutil
import subprocess
import tempfile

from buildingspy.development.refactor import write_package_order
from buildingspy.simulate.Dymola import Simulator

TARGET_PACKAGE_NAME = 'IBPSA.Utilities.IO.SDF'  # Fully qualified class name
SDF_BASE_URL = 'https://github.com/ScientificDataFormat/SDF-Modelica'


def main():
    parser = argparse.ArgumentParser(description='Import the SDF library')
    parser.add_argument('sdf_version', help='SDF Library version, e.g., 0.4.4')
    parser.add_argument(
        '--test',
        action='store_true',
        help='Whether to run a validation model to test the import',
    )
    args = parser.parse_args()

    get_library_path = subprocess.run(
        ['git', '-C', os.path.dirname(__file__), 'rev-parse', '--show-toplevel'],
        check=True,
        capture_output=True,
        text=True,
    )
    library_path = get_library_path.stdout.strip()

    # Directory is automatically cleaned up after the with block, even if there's an error.
    with tempfile.TemporaryDirectory() as temp_dir:
        import_sdf(args.sdf_version, library_path, temp_dir)

    if args.test:
        print('Running a validation model to test the import...')
        simulator = Simulator(
            f'{TARGET_PACKAGE_NAME}.Examples.InterpolationMethods',
            packagePath=os.path.join(library_path, TARGET_PACKAGE_NAME.split('.')[0]),
        )
        simulator.simulate()

        if os.path.isfile('./BuildingsPy.log'):
            with open('./BuildingsPy.log', 'r') as FH:
                log = FH.read()
                if re.search(r'***\s*Error', log):
                    print('Validation model failed.')
                    exit(1)

        print('Validation model passed.')


def import_sdf(sdf_version, library_path, temp_dir):
    # Download release artifacts and unzip.
    subprocess.run(
        [
            'wget',
            '--output-document',
            f'{temp_dir}/SDF-Modelica.zip',
            f'{SDF_BASE_URL}/releases/download/v{sdf_version}/SDF-Modelica-{sdf_version}.zip',
        ],
        check=True,
    )
    subprocess.run(['unzip', 'SDF-Modelica.zip'], cwd=temp_dir, check=True)

    # Copy the SDF library into the library directory.
    package_path = os.path.join(library_path, TARGET_PACKAGE_NAME.replace('.', os.path.sep))
    shutil.copytree(
        f'{temp_dir}/SDF',
        package_path,
        dirs_exist_ok=True,  # So that the script can be used to update SDF version.
    )

    # Modify package.order and within clauses.
    write_package_order(os.path.dirname(package_path), recursive=False)
    modify_mo_files(library_path)


def modify_mo_files(library_path):
    sdf_package_relpath = TARGET_PACKAGE_NAME.replace('.', os.path.sep)
    sdf_package_path = os.path.join(library_path, sdf_package_relpath)
    # Walk through all directories and files in package.
    for dirpath, _, filenames in os.walk(sdf_package_path):
        # Filter for .mo files.
        mo_files = [f for f in filenames if f.endswith('.mo')]

        for mo_file in mo_files:
            file_path = os.path.join(dirpath, mo_file)

            try:
                # Read the file content.
                with open(file_path, 'r', encoding='utf-8') as file:
                    content = file.read()

                package_name = re.sub(os.path.sep, '.', os.path.relpath(dirpath, library_path))
                if mo_file == 'package.mo':  # Trim last subpackage.
                    package_name = re.split(r'\.', package_name)
                    package_name.pop()
                    package_name = '.'.join(package_name)

                # Change within clause.
                modified_content = re.sub(
                    r'(^\s*within\s+)(.*;)',
                    r'\1' + f'{package_name};',
                    content
                )

                # Change URI.
                modified_content = re.sub(
                    r'modelica://SDF(.*)',
                    rf'modelica://{sdf_package_relpath}\1',
                    modified_content,
                )

                if modified_content != content:
                    # Write the modified content back to the file.
                    with open(file_path, 'w', encoding='utf-8') as file:
                        file.write(modified_content)

            except Exception as e:
                print(f'Error processing {file_path}: {str(e)}')


if __name__ == '__main__':
    main()
