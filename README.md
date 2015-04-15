# KickS

KickS is a mini command line application clone of Kickstarter. It uses the Commander gem to manage command line arguments. 

##Dependencies
  - sqlite3
  - Sequel
  - RSpec

##Installation
KickS assumes you have Ruby and Bundler.

If you don’t have SQLite, you will have to install it. 
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
- [target_amount] accepts numeric and dollar symbol prefix
- If using the dollar symbol prefix, you have to escape with single quotes '$90' or backslash
- examples:  \$.90, '$900.00', '$9000', 900.00


Show status of project (backers and success):
```sh
./campaign.rb list [project_name]
```


Back a project:
```sh
./back_project.rb back [user_name] [project_name] [credit_card] [backed_amount]
```
- [backed_amount] only accepts numeric, no dollar symbol prefix
- Accepts dollars and cents 
- examples: 0.10, 10.00, 100.00, 100


Show projects that user has backed:
./backed_project.rb backer [user_name]
```