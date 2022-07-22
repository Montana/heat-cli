[![Build Status](https://app.travis-ci.com/Montana/heat-cli.svg?branch=master)](https://app.travis-ci.com/Montana/heat-cli)

# heat-cli

Heat is a collection of fun tools that have nothing to do with one another. It's a Swiss army knife of fun in the CLI, you can look busy, check the weather, ping an API, and a lot more all in one central shell script. Functionality will be added.

![heat-cli](https://user-images.githubusercontent.com/20936398/180102810-9eedbee0-aa9e-4840-9a61-c0e2c05cb7da.png)

## Usage

Practical usage of Heat is to clone this repo, install `heat.sh` by running `chmod u+x heat.sh`, then rename `heat.sh` to `heat`, and place it in your `/usr/local/bin` directory. 

## Manpage

- [l] - make sure heat-cli is installed
- [v] - version of heat-cli
- [r] - we turning up the heat?
- [h] - see if heat is working
- [z] - check weather 
- [c] - usage
- [t] - look busy 

So you'd run `heat -z` to get the weather as an example. This is what `heat -z` looks like: 

<img width="895" alt="Screen Shot 2022-07-20 at 4 51 05 PM" src="https://user-images.githubusercontent.com/20936398/180101609-85896117-d40b-43a9-bf37-640154c628eb.png">

## Travis CI

Here's the current `.travis.yml` file I've created for my project called `heat-cli`: 

```yaml
language: shell 
before_script: 
  - chmod u+x heat 
  - sudo chmod +x /usr/local/bin
  - sudo mv heat /usr/local/bin
script: 
  - heat -v 
  - heat -c 
  - heat -z
```

In the above `.travis.yml` I've instructed Travis to change permissions to some directories, move the file entitled `heat`, which is `heat-cli`, over to `/usr/local/bin`. You'll then notice I run Heat by just running some test commands, such as: 

```bash
heat -v 
heat -c 
heat -z
```

This is what it will look like if your build is successful, it's going to call a weather API and spit the results out in a VM:

<img width="1338" alt="Screen Shot 2022-07-21 at 6 10 06 PM" src="https://user-images.githubusercontent.com/20936398/180340384-43a7a7da-49f7-4fad-afb6-15b9eab5f992.png">

## Conclusion 

Turn up the heat, and try Heat out yourself.

If you have any questions about Heat please email me at [montana@linux.com](mailto:montana@linux.com).

* Author - Montana Mendy
