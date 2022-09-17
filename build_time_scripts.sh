# exit on errors
set -e
# now let's fire up all the scripts from the
# directory which we received as a second argument
if [ "$(ls $1)" ]; then 
	for script in $1/*
	do
		echo "executing $script"
		$script
	done
else
	echo "custom scripts directory is empty"
fi
