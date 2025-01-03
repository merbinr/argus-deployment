set -ex

if ! command -v certbot &> /dev/null; then
    echo "Error: certbot is not installed. Please install certbot and try again."
    exit 1
fi

if ! command -v git &> /dev/null; then
    echo "Error: git is not installed. Please install git and try again."
    exit 1
fi


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

if [ -z "$ARGUS_CERTBOT_DOMAIN_VALUE" ]; then
  echo "Error: ARGUS_CERTBOT_DOMAIN_VALUE is not set." >&2
  exit 1
fi

if [ -z "$ARGUS_CERTBOT_EMAIL_VALUE" ]; then
  echo "Error: ARGUS_CERTBOT_EMAIL_VALUE is not set." >&2
  exit 1
fi

envsubst < nginx/nginx.conf.template > nginx/nginx.conf

docker compose -f docker-compose/docker-compose.staging.yml down
docker system prune -f
certbot certonly --standalone -d $domain_value --non-interactive --agree-tos --email $CERTBOT_EMAIL 
docker image rm docker image rm docker-compose-deduplicator-stage-three docker-compose-catcher docker-compose-deduplicator-stage-two docker-compose-deduplicator-stage-one || true
docker compose -f docker-compose/docker-compose.staging.yml up
