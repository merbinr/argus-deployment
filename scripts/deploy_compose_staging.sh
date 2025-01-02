set -ex

# Cloning catcher and deduplicator
echo "Cloning catcher"
if [ -d "catcher" ]; then
    echo "Catcher directory exists. Ignore cloning..."
else
    echo "Catcher directory does not exist. Cloning..."
    git clone https://github.com/merbinr/catcher.git
    echo "Cloning catcher done."
fi

echo "Cloning deduplicator"
if [ -d "deduplicator" ]; then
    echo "Deduplicator directory exists. Ignore cloning..."
else
    echo "Deduplicator directory does not exist. Cloning..."
    git clone https://github.com/merbinr/deduplicator.git
    echo "Cloning deduplicator done."
fi

if [ ! -f ".env" ]; then
  echo "Error: .env file does not exist, Please create it, use the .env.example as a template"
  exit 1
fi

mkdir -p logs/catcher logs/deduplicator_stage_one logs/deduplicator_stage_two logs/deduplicator_stage_three

# Load environment variables
export $(cat .env | xargs)

docker compose -f docker-compose/docker-compose.staging.yml down
docker system prune -f
docker image rm docker image rm docker-compose-deduplicator-stage-three docker-compose-catcher docker-compose-deduplicator-stage-two docker-compose-deduplicator-stage-one || true
docker compose -f docker-compose/docker-compose.staging.yml up
