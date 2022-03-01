
$ROOT_DIR="$( Get-Location )"
$SOURCE_DIR="$ROOT_DIR\src"
$BUILD_DIR="$ROOT_DIR\build"

if (Test-Path -Path $BUILD_DIR) {
	
	Get-ChildItem -Path $BUILD_DIR -Attributes !Directory | foreach {
		echo $_
	}
	
} else {
	echo "false"
}