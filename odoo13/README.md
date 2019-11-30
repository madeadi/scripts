To start: `docker-compose up`

Then, to force database to initiate: 
https://github.com/odoo/odoo/issues/27447
1. login to the container: `docker-compose exec odoo bash`
2. Run the initialisation: `odoo -i base -d odoo --stop-after-init --db_host=db -r odoo -w odoo`
3. Restart docker up

To login:
1. Go to http://localhost:8069/
2. Select the db
3. Login to Odoo with default username (admin) and password (admin): https://stackoverflow.com/questions/34239274/how-to-log-in-to-odoo-after-creating-a-database