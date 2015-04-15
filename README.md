# KickS

KickS is a mini command line application clone of Kickstarter. It uses [Commander] to manage command line arguments. 

##Dependencies
  - sqlite3
  - Sequel
  - RSpec

##Installation
KickS assumes you have Ruby and Bundler.

If you don’t already have SQLite, you will have to install it. 
Homebrew:  ```sh brew install sqlite```

##Build
Install gems and build database:
```sh
sh deploy.sh
```

##Commands
Create a project:
```sh
./campaign.rb project [project_name] [creator_name] [target_amount]
```

Show status of project (backers and success):
```sh
./campaign.rb list [project_name]
```

Back a project:
```sh
./back_project.rb back [user_name] [project_name] [credit_card] [backed_amount]
```

Show projects that user has backed:
./backed_project.rb backer [user_name]
```

[Commander]:https://github.com/tj/commander