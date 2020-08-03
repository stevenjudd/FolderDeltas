$FoldersToCreate = @(
    "$env:TEMP\odmon",
    "$env:TEMP\odmon\modify",
    "$env:TEMP\odmon\toDelete"
)
$FilesToCreate = @(
    "$env:TEMP\odmon\deleteMe.txt",
    "$env:TEMP\odmon\root.txt",
    "$env:TEMP\odmon\modify\ModFile1.txt",
    "$env:TEMP\odmon\modify\ModFile2.txt",
    "$env:TEMP\odmon\modify\ModFile3.txt",
    "$env:TEMP\odmon\toDelete\DelFile1.txt",
    "$env:TEMP\odmon\toDelete\DelFile2.txt"
)

foreach ($item in $FoldersToCreate) {
    New-Item -Path $item -ItemType Directory
}

foreach ($item in $FilesToCreate) {
    New-Item -Path $item -ItemType File
}