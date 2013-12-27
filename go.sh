
sudo rvm --default use ruby-1.9.3
rake generate
rake deploy
git add .
git commit -m "green gerong blog"
git push origin source