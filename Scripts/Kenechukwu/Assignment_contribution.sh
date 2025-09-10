# Database connection
#db_host="localhost"
#db_port="5432"
#db_name="posey" 
#db_user="airflow"
#db_password="airflow"

#PGPASSWORD=airflow psql -h localhost -p 5432 -U airflow -d posey -c "SELECT * FROM web_events LIMIT 10;"

PGPASSWORD=airflow psql -h localhost -p 5432 -U airflow -d posey