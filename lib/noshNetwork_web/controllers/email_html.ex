defmodule NoshNetworkWeb.EmailHTML do
  use NoshNetworkWeb, :html
  embed_templates "email_html/*.html"
  embed_templates "email_html/*.text", suffix: "_text"
end
