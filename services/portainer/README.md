
docker volume create -d local \
  --opt type=none \
  --opt o=bind \
  --opt device=~/docker_data/portainer/_data \
  portainer_data
