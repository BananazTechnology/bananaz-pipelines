## UpdateAllSecrets Script

### Description
This project can loop 75 of the newest updates/created repos and can create/update all necessary secrets for each repo.

### Env Setup
* Contact `contact@bananaz.tech` for access to:
  * `request_secrets` file
  * `pipeline_secrets` file
* Ensure you have python3 installed
* Install the NaCL library: `pip3 install pynacl`

## Execute
Ensure you have followed the Env Setup steps above and have `python3` and the `pynacl` lib available
```bash
bash UpdateAllSecrets.sh
```