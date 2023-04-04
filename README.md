### Hexlet tests and linter status:
[![Actions Status](https://github.com/kalash-job/rails-project-65/workflows/hexlet-check/badge.svg)](https://github.com/kalash-job/rails-project-65/actions)
[![Actions Status](https://github.com/kalash-job/rails-project-65/workflows/main/badge.svg)](https://github.com/kalash-job/rails-project-65/actions)

<h1>Project "Classifieds platform".</h1>
<p>This project is available on railway by the <a href="https://railsclassifiedsplatform-production.up.railway.app/">Rails Classifieds Platform</a></p>

<h2>About the project:</h2>
<p>This is the third project from the course Ruby on Rails developer by Hexlet.</p>
<p>The purpose of the project is to create a Classifieds platform, like Avito.ru, but simpler.</p>
<p>Users use the Classifieds platform for looking and searching bulletins that were published by other users.</p>
<p><b>Users without login</b> (visitors) can see a list of bulletins and open details for every published bulletin.</p>
<p><b>Authenticated users</b> additionally can create bulletins, update and archive them and send them on moderation. Also, they can use a panel My bulletins.</p>
<p><b>Users with admin permissions</b> additionally can use an Admin panel. There they can publish or reject bulletins on moderation, archive them, and create, update, and delete categories.</p>
<p>Project error tracking is performed using Rollbar.</p>
<p>For keeping images of bulletins is used Amazon AWS  S3 bucket.</p>

<h3>The main technologies used during project development were the following:</h3>
<ul>
<li>Ruby 3.1.2.</li>
<li>Ruby on Rails 7.</li>
<li>gem aasm.</li>
<li>gem faker.</li>
<li>gem minitest-power_assert.</li>
<li>gem omniauth-github.</li>
<li>gem pundit.</li>
<li>gem rails-i18n.</li>
<li>gem ransack.</li>
<li>gem simple_form.</li>
<li>gem slim-rails.</li>
<li>gem rubocop-rails.</li>
</ul>

<h2>Common instructions for local deployment:</h2>
<p>After <b>git clone</b> and <b>bundle install</b> commands you should execute the <b>make setup</b> command.</p>
<p>These actions will create a database structure locally and fill it with fake data.</p>
<p>You can also run tests with the <b>make tests</b> command. It will run a check by tests of controllers and system tests.</p>
<p>So after that, you can use the command <b>make start</b> and check the website working on <a href="http://127.0.0.1:3000">localhost</a>.</p>
<p>Later you can log in to this site using your GitHub account. After that, your account will be created.</p>
<p>You can make your account an admin account. For that, you should change <b>user.admin</b> value from false to true for your user using migration or console.</p>