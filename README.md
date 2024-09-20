# NIX Shell Environments

This is a main repository that stores my [NIX](https://nixos.org/) configurations for certain [nix-shell](https://nix.dev/manual/nix/2.24/command-ref/nix-shell.html) environments.


Currently I have environments for:
* [Commercetools](./commercetools/)
* [Shopify](./shopify/)

On my list of to-dos:
* Magento 2 (with Docker + [dev-environment](./environments/dev-environment/))

## Installation

This requires the [Single-user NIX installtion](https://nixos.org/download/) package. Note: this is NOT NixOS but just the package manager.

Then all you have to do is `cd` into the environment you want to load and run the available script:
```bash
./start.sh <my_project_dir>
```

## FAQs

> What are you trying to solve?

NIX solves the "it worked on my machine" and the "it worked until I rebuilt it" syndromes.

> Why are you doing it?

Naturally, whenever there is a need to re-platform / learn new software, there is inevitably a whole bunch of dependencies required. NIX allows me to load all the necessary dependencies required via declarative schema into an independent shell which better compartmentalises my environments.

> Why not use Docker instead?

I use NIX for environments, Docker for projects. I value the "package-manager" aspect of it more. It can achieve more with less code. It's also pretty handy when transferring over to a new computer. All I need to do is clone this repo, install `nix-shell` and BAMM, all the necessary programs are available to me for developing in that respective environment. Additionally, it feels lighter than Docker (don't know if this is true).
