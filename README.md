# Ishan's dotfiles
These are the config files I use for my local environment. I took bits and pieces from [mathiasbynens]("https://github.com/mathiasbynens/dotfiles"), [paulirish]("https://github.com/paulirish/dotfiles"), and [thesephist]("https://github.com/thesephist/dotfiles").

The key differences are a couple functions I've written in the `.functions` file.
- `mkgit`: Creates a local git repo with README, .gitignore, and .vscode files and a remote repo on GitHub using my personal CLI auth.
- `generate`: Runs a local fork of stable diffusion on my M1 MacBook. If you want to set this up for yourself you can follow [this tutorial from Replicate]("https://replicate.com/blog/run-stable-diffusion-on-m1-mac").
- `refresh_dots`: Syncs my dotfiles repo with my local dotfiles. This could be reversed to install the dotfiles on git onto a new machine.
- `get_papers`: Downloads any new research paper from my Notion database using a [tool I created](https://github.com/ishan0102/paper-dl)
- `catpdf`: Displays a PDF file in text form using the [pdftotext](https://www.xpdfreader.com/pdftotext-man.html) command.
- `rendermd`: Renders a Markdown file every `n` seconds using the [`glow`](https://github.com/charmbracelet/glow) rendering tool. I use this for classes where I take notes in Markdown.

Something else I added is [ai-cli](https://github.com/abhagsain/ai-cli), which enables an `ai ask` function that calls the GPT-3 API to generate CLI commands. I may write my own version of this in the future for more general queries.

Enjoy!
