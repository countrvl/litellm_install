English | [Русский](README_RU.md)

# LiteLLM & OpenClaw Installer

This script automates the installation and configuration of [LiteLLM Proxy](https://litellm.ai/) with support for multiple Large Language Models (LLM), including GigaChat, Anthropic, and DeepSeek, on Debian/Ubuntu operating systems. After successfully setting up LiteLLM, the script optionally offers to run the official [OpenClaw](https://openclaw.ai/) installer (https://openclaw.ai/install.sh).

LiteLLM will be configured as a `systemd` service, ensuring its automatic startup and reliable operation.

### LiteLLM Resources:
*   **Official Website:** [litellm.ai](https://litellm.ai/)
*   **Documentation:** [docs.litellm.ai](https://docs.litellm.ai/)
*   **GitHub:** [github.com/BerriAI/litellm](https://github.com/BerriAI/litellm)

## Features

*   **OS Support:** Debian and Ubuntu.
*   **Interactive LLM Selection:** Choose which LLMs you want to use:
    *   [GigaChat](https://developers.sber.ru/docs/ru/gigachat/models)
    *   [Anthropic](https://docs.anthropic.com/en/docs/about-claude/models/overview)
    *   [DeepSeek](https://platform.deepseek.com/docs)
*   **Provider Credentials Input:** For GigaChat, enter Authorization Key (`base64(client_id:client_secret)`) as `GIGACHAT_CREDENTIALS`. For other providers, enter API keys.
*   **OAuth-native GigaChat Mode:** LiteLLM handles OAuth token lifecycle internally for GigaChat in `v1.82.x`.
*   **Visible Credentials Input:** Entered credentials are echoed back in TTY for copy/paste verification.
*   **Explicit Models + Fallbacks:** Installer generates fixed model aliases, `router_settings`, and fallback rules by provider priority.
*   **LiteLLM Port Selection:** Specify the desired port for the LiteLLM Proxy.
*   **Isolated Installation:** LiteLLM is installed in a Python virtual environment (`venv`).
*   **Autostart:** LiteLLM is configured as a `systemd` service for automatic startup.
*   **Optional OpenClaw Installation:** After LiteLLM setup, the script will offer to run the official OpenClaw installer.
*   **Management:** Supports `--update` for LiteLLM updates and `--uninstall` for complete removal (service, installation files, `/etc/litellm`, system user/group `litellm`).

## Installation

To run the installer, execute the following command in your terminal:

```bash
curl -sSL https://raw.githubusercontent.com/countrvl/litellm_install/main/install.sh | sudo bash
```

### Installation Steps:

1.  **Run the script:** Execute the command above. The script will request `sudo` privileges.
2.  **LiteLLM Port Selection:** Enter the desired port for LiteLLM (default `4000`).
3.  **LLM Selection:** Choose the numbers of the LLMs you want to use (e.g., `1 3` for GigaChat and DeepSeek).
4.  **DeepSeek/Anthropic Priority:** If both are selected, provide the order (`1 2` or `2 1`).
5.  **Credentials Entry:** For GigaChat, enter Authorization Key (`base64(client_id:client_secret)`). For other providers, enter API keys.
6.  **OpenClaw Installation (optional):** After LiteLLM setup, the script will offer to run the official OpenClaw installer.


## Usage

After successful installation, LiteLLM will be accessible at `http://localhost:<YOUR_LITELLM_PORT>`.

### OpenClaw Configuration

To connect OpenClaw to your LiteLLM Proxy, use the following parameters:

*   **API Base:** `http://localhost:<YOUR_LITELLM_PORT>/openai/v1`
*   **API Key:** not required by this installer by default
*   **Model:** `gigachat-2` (if GigaChat is selected) or any model from `GET /openai/v1/models`

### GigaChat OAuth Credentials (Default)

For GigaChat, this installer uses LiteLLM native OAuth credentials mode:

- `api_key: os.environ/GIGACHAT_CREDENTIALS`
- expected value: `GIGACHAT_CREDENTIALS=<base64(client_id:client_secret)>`
- runtime env file: `/etc/litellm/litellm.env`
- no external token file/timer is required

Operational note:

- avoid aggressive `/health` polling (especially short intervals), since model-level probes can increase upstream OAuth pressure and cause `429 Too Many Requests`.
- installer/update does not use `/health` as a success gate; service readiness is determined by `systemd` active state.

Config generation is deterministic:

- models:
  - GigaChat: `gigachat-2` -> `gigachat/GigaChat-2`
  - DeepSeek: `deepseek-reasoner`, `deepseek-chat`
  - Anthropic: `claude-sonnet`, `claude-haiku`
- always included: `litellm_settings`, `router_settings`
- fallback rules:
  - 1 provider: no fallback
  - 2 providers: fallbacks from primary provider to secondary provider
  - 3 providers: priority is applied between DeepSeek/Anthropic; `gigachat-2` is always the last fallback for primary-provider models

### Update LiteLLM

To update LiteLLM to version 1.81.12 or newer:

```bash
sudo /opt/litellm/install.sh --update
```

### Diagnostics

```bash
sudo /opt/litellm/venv/bin/pip show litellm | grep -i '^Version'
sudo systemctl status litellm --no-pager -l
sudo grep -n "gigachat/GigaChat-2\\|deepseek-reasoner\\|claude-sonnet\\|fallbacks\\|GIGACHAT_CREDENTIALS" /opt/litellm/config/config.yaml
sudo grep -n '^GIGACHAT_CREDENTIALS=' /etc/litellm/litellm.env
curl -sS http://127.0.0.1:4000/openai/v1/models | jq .
curl -sS http://127.0.0.1:4000/openai/v1/chat/completions \
  -H "Content-Type: application/json" \
  -d '{"model":"gigachat-2","messages":[{"role":"user","content":"reply with one word: ok"}],"max_tokens":8,"temperature":0}' | jq .
```

### Uninstall LiteLLM

To completely remove LiteLLM and all its components:

```bash
sudo /opt/litellm/install.sh --uninstall
```

`--uninstall` removes:
- `litellm.service` (`systemd` stop/disable + unit file removal)
- `/opt/litellm`
- `/etc/litellm` (including `litellm.env`)
- legacy refresh artifacts (`litellm-token-refresh.service`, `litellm-token-refresh.timer`, `/etc/litellm/tokens`, `/etc/litellm/gigachat.env`) if present
- system user `litellm` and group `litellm` (if present)

## Supported LLMs

*   **[GigaChat](https://developers.sber.ru/docs/ru/gigachat/models):** `gigachat/GigaChat-2` (`model_name: gigachat-2`)
*   **[Anthropic](https://docs.anthropic.com/en/docs/about-claude/models/overview):** `anthropic/claude-sonnet-4-5` (`claude-sonnet`), `anthropic/claude-haiku-4-5` (`claude-haiku`)
*   **[DeepSeek](https://platform.deepseek.com/docs):** `deepseek/deepseek-reasoner` (`deepseek-reasoner`), `deepseek/deepseek-chat` (`deepseek-chat`)

## License

This project is distributed under the MIT License. See the [LICENSE](LICENSE) file for more information.
