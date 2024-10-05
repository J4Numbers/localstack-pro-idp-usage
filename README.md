# Localstack Pro OIDC usage bug reproduction

This is a micro-repository that exists to showcase how to reproduce [issue 11641][1] in
Localstack Pro.

[1]: https://github.com/localstack/localstack/issues/11641

## How to use

1. Create a new `localstack.local.env` file which contains your Localstack Pro key
   (see `localstack.example.env` for the expected format).
2. Run `docker compose up -d localstack keycloak` to create the keycloak and Localstack
   servers.
3. Log into Keycloak at http://localhost:8080 with the username and password of `admin`.
4. Create a new client (Clients > Create client) which has the following settings:
    1. Client ID set to `demo-app-1` (can be other values too)
    2. Valid redirect URIs set to `*`
    3. Web origins set to `*`
    4. Client authentication is set to `On`
    5. Standard flow and Direct access grants are enabled in the authentication flows
5. Take the client id and secret from that created client (demo-app-1 > Credentials) and
   run the following with them: `. ./localstack-setup.bash <client_id> <client_secret>`
6. Note down the created client ID, the client secret, and the User Pool ID from the final
   command. Also copy the ProviderDetails response block for later from the previous command.
7. Modify `openresty/nginx.conf` and replace the variable settings for `$client_id`,
   `$client_secret`, and `$user_pool` with the values noted down in the last step
8. Run `docker compose up -d` to stand up `openresty` and the test service behind it
9. Visit http://localhost:8000/auth and attempt to log in with the `demo-app-1` IdP.
    1. This is the first issue with Localstack Pro, where the details of individual IdPs are
       not filled into the login page.
10. Run the following in the web developer console to get around this:
    `IDP_PROVIDERS[0].details = <ProviderDetails block from step 6>`
11. Log in with the IdP button again (and if prompted, enter admin/admin on the keycloak server)
    1. At this point, Localstack will hang on the idpresponse endpoint with no further actions
    2. Notably, the URL will contain valid items for a session, including the `session_state` and
       an authorization code
12. When finished investigating, run `docker compose down` to close down all containers
