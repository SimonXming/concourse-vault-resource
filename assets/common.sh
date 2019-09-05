login_approle() {
    vault_role_id="$1"
    vault_secret_id="$2"
    token=$(vault write -format=json auth/approle/login role_id=${vault_role_id} secret_id=${vault_secret_id} | jq -r '.auth.client_token')
    if [ -z "${token}" ]; then
        echo "ERROR: No token retrieved"
	return 1
    fi
    echo -n "${token}" > ~/.vault-token
}

login_github() {
    github_personal_access_token="$1"
    token=$(vault login -token-only -method=github token=${github_personal_access_token})
    if [ -z "${token}" ]; then
        echo "ERROR: No token retrieved"
    return 1
    fi
    echo -n "${token}" > ~/.vault-token
}

login_token() {
    vault_token="$1"
    token=$(vault login -token-only token=${vault_token})
    if [ -z "${token}" ]; then
        echo "ERROR: No token retrieved"
	return 1
    fi
    echo -n "${token}" > ~/.vault-token
}


get_secret() {
    vault read -format=json ${1} | jq -r '.data'
}
