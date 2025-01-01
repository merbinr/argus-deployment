set -ex

# Cloning catcher and deduplicator
echo "Cloning catcher"
if [ -d "catcher" ]; then
    echo "Catcher directory exists. Ignore cloning..."
else
    echo "Catcher directory does not exist. Cloning..."
    git clone git@github.com:merbinr/catcher.git
    echo "Cloning catcher done."
fi

echo "Cloning deduplicator"
if [ -d "deduplicator" ]; then
    echo "Deduplicator directory exists. Ignore cloning..."
else
    echo "Deduplicator directory does not exist. Cloning..."
    git clone git@github.com:merbinr/deduplicator.git
    echo "Cloning deduplicator done."
fi

if [ ! -f ".env" ]; then
  echo "Error: .env file does not exist, Please create it, use the .env.example as a template"
  exit 1
fi
