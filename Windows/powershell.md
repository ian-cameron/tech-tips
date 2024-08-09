## Rename files to only have ASCII characters (To be in a ZIP archive)
`
# Define the directory to scan
$directory = 'C:\YourDirectory'

# Get all files in the directory
$files = Get-ChildItem -Path $directory -Recurse -File

# Iterate over each file
foreach($file in $files) {
    # Check if the file name contains any non-ASCII characters
    if($file.Name -match '[^\x00-\x7F]') {
        # Replace non-ASCII characters with a hyphen
        $newName = $file.Name -replace '[^\x00-\x7F]', '-'

        # Rename the file
        Rename-Item -Path $file.FullName -NewName $newName
    }
}
`