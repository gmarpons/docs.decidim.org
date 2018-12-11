# docs.decidim.org

Decidim documentation site

This is the landing page and main website for docs.

If you want to contribute to any of this documents you can make a Pull Request on the documents:

* [Documentation Authoring and Publishing Guide](https://github.com/decidim/docs-authoring-guide)
* [Administration Manual](https://github.com/decidim/docs-admin-manual)
* [Configuration Tutorial](https://github.com/decidim/docs-config-tutorial)
* [Deploy and Admin](https://github.com/decidim/docs-deploy-and-admin)
* [Developers Manual](https://github.com/decidim/docs-developers-manual)
* [Features](https://github.com/decidim/docs-features)
* [Social Contract](https://github.com/decidim/docs-social-contract)
* [Whitepaper](https://github.com/decidim/docs-whitepaper)

To develop this site you need to have the antora packages installed:

```shell
npm install -g @antora/cli
npm install -g @antora/site-generator-default
```

You might need to install the packages `libcurl4-openssl-dev` and `libssh-dev` for installing antora.

```shell
sudo apt install libcurl4-openssl-dev libssh-dev
```

## Run

```shell
$ antora site.yml
```

You can see the generated site on `build/`.

## Dependencies

node v8.9.4
antora v1.1.1

We recommend using nvm for working with nodejs.

## Troubleshooting


### @antora/site-generator-default package
If you see an error:

```shell
error: Generator not found or failed to load. Try installing the `@antora/site-generator-default' package.
Add the --stacktrace option to see the cause.
```

First check out if it's installed correctly. If not, you should check that you're using the correct version of node. We recommend using nvm.

### Old UI / caching issues

Delete .cache/.

```shell
rm -r .cache/
```

To develop this site locally you should change the `site.yml` configuration. Remember to correct it again before making a Pull Request.

```yaml
  - url: &landing /path/to/your/local/docs.decidim.org
```
