#!/usr/bin/env python3

"""Import the SDF Library into IBPSA.

This script downloads a specified version of the SDF library from GitHub,
integrates it into IBPSA as a new package, and optionally runs a validation test.

Usage:
    From 'modelica-ibpsa/.' (where the directory 'IBPSA' is located) run:
    > ./bin/importSDF.py VERSION [--test]

Arguments:
    VERSION: SDF Library version (e.g., 0.4.4)
    --test: Optional flag to run a validation test
"""

import argparse
import os
import re
import subprocess
import tempfile

from buildingspy.development.refactor import write_package_order
from buildingspy.simulate.Dymola import Simulator

TARGET_PACKAGE_NAME = 'IBPSA.Utilities.IO.SDF'
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

    # Directory is automatically cleaned up after the with block, even if there's an error.
    with tempfile.TemporaryDirectory() as temp_dir:
        import_sdf_into_mbl(args.sdf_version, temp_dir)

    if args.test:
        print('Running a validation model to test the import...')
        simulator = Simulator(
            f'{TARGET_PACKAGE_NAME}.Examples.InterpolationMethods',
            packagePath=TARGET_PACKAGE_NAME.split('.')[0],
        )
        simulator.simulate()

        if os.path.isfile('./BuildingsPy.log'):
            with open('./BuildingsPy.log', 'r') as FH:
                log = FH.read()
                if re.search(r'***\s*Error', log):
                    print('Validation model failed.')
                    exit(1)

        print('Validation model passed.')


def import_sdf_into_mbl(sdf_version, temp_dir):
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

    # Copy the SDF library into the Modelica library directory.
    package_path = TARGET_PACKAGE_NAME.replace('.', os.path.sep)
    subprocess.run(
        ['cp', '-r', f'{temp_dir}/SDF', f'{package_path}'],
        check=True,
    )

    # Modify package.order and within clauses.
    write_package_order(os.path.dirname(package_path), recursive=False)
    modify_mo_files(package_path)


def modify_mo_files(package_path):
    library_name = package_path.split(os.path.sep)[0]
    # Walk through all directories and files under 'package_path'.
    for dirpath, _, filenames in os.walk(package_path):
        # Filter for .mo files.
        mo_files = [f for f in filenames if f.endswith('.mo')]

        for mo_file in mo_files:
            file_path = os.path.join(dirpath, mo_file)

            try:
                # Read the file content.
                with open(file_path, 'r', encoding='utf-8') as file:
                    content = file.read()

                package_name = re.sub(
                    os.path.sep,
                    '.',
                    re.sub(
                        f'.*{library_name}',
                        library_name,
                        os.path.abspath(dirpath),
                    ),
                )
                if mo_file == 'package.mo':  # Trim last subpackage.
                    package_name = re.split(r'\.', package_name)
                    package_name.pop()
                    package_name = '.'.join(package_name)

                # Change within clause.
                modified_content = re.sub(
                    r'(^\s*within\s+)(.*;)', r'\1' + f'{package_name};', content
                )

                # Change URI.
                modified_content = re.sub(
                    r'modelica://SDF(.*)',
                    rf'modelica://{package_path}\1',
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
