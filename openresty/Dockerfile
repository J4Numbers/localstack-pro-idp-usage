FROM openresty/openresty:1.21.4.1-0-focal

# install dependencies
RUN ["luarocks", "install", "lua-resty-session", "4.0.3"]
RUN ["luarocks", "install", "lua-resty-http"]
RUN ["luarocks", "install", "lua-resty-jwt"]
RUN ["luarocks", "install", "lua-resty-openidc"]
