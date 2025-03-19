# Orai Servic

Welcome to the Orai Public Good Service. This service offers essential tools and endpoints for interacting with the Orai network, including RPC, API, gRPC, seed nodes, and snapshots to help you get started or stay in sync.

## Services

| Service  | URL/Information                                                     | Description                                                         |
|----------|---------------------------------------------------------------------|---------------------------------------------------------------------|
| RPC      | https://rpc.orai.pathrocknetwork.org/                               | Remote Procedure Call endpoint for interacting with the Orai blockchain. |
| API      | https://api.orai.pathrocknetwork.org/                               | RESTful API for accessing Orai network data.                        |
| gRPC     | https://grpc.orai.pathrocknetwork.org/                              | gRPC endpoint for efficient, low-latency communication with the Orai network. |
| Seed     | 4ce3325d935d37912793ee8dcf907ad80075aa45@seed.orai.pathrocknetwork.org:26656 | Seed node for peer discovery in the Orai network.                   |
| Snapshot | http://snapshot.orai.pathrocknetwork.org/orai_latest.tar.lz4        | Latest snapshot of the Orai blockchain for quick synchronization.   |

## Snapshot instructions

```
sudo systemctl stop oraid
cp $HOME/.oraid/data/priv_validator_state.json $HOME/.oraid/priv_validator_state.json.backup
rm -rf $HOME/.oraid/data
curl http://snapshot.orai.pathrocknetwork.org/orai_latest.tar.lz4 | lz4 -dc - | tar -xf - -C $HOME/.oraid
mv $HOME/.oraid/priv_validator_state.json.backup $HOME/.oraid/data/priv_validator_state.json
sudo systemctl restart oraid && sudo journalctl -u oraid -f
```
