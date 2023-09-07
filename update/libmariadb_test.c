/* 
   To compile: gcc libmariadb_test.c -o libmariadb_test -lmariadb
   To run: ./libmariadb_test -h localhost -u root -p ''
*/

#include <stdio.h>
#include <string.h>
#include <stdlib.h>
#include <mysql/mysql.h>
#include <unistd.h>
#include <getopt.h>
#include <time.h>

// Create a database if it doesn't exist
void createDatabaseIfNotExists(MYSQL *conn, const char *dbName) {
    char query[100];
    snprintf(query, sizeof(query), "CREATE DATABASE IF NOT EXISTS %s", dbName);

    if (mysql_query(conn, query)) {
        fprintf(stderr, "Failed to create database '%s': %s\n", dbName, mysql_error(conn));
        mysql_close(conn);
        exit(1);
    }
    printf("Database '%s' created or already exists.\n", dbName);
}

// Ceate a table and insert some data
void createTableAndInsertData(MYSQL *conn, const char *dbName, const char *tableName) {
    createDatabaseIfNotExists(conn, dbName);

    if (mysql_select_db(conn, dbName)) {
        fprintf(stderr, "Failed to select database '%s': %s\n", dbName, mysql_error(conn));
        mysql_close(conn);
        exit(1);
    }

    char query[200];
    snprintf(query, sizeof(query), "CREATE TABLE IF NOT EXISTS %s (id INT AUTO_INCREMENT PRIMARY KEY, name VARCHAR(255))", tableName);

    if (mysql_query(conn, query)) {
        fprintf(stderr, "Failed to create table '%s': %s\n", tableName, mysql_error(conn));
        mysql_close(conn);
        exit(1);
    }
    printf("Table '%s' created successfully in database '%s'.\n", tableName, dbName);

    snprintf(query, sizeof(query), "INSERT INTO %s (name) VALUES ('SUSE'), ('Tiger'), ('Fish')", tableName);
    if (mysql_query(conn, query)) {
        fprintf(stderr, "Failed to insert data into table '%s': %s\n", tableName, mysql_error(conn));
        mysql_close(conn);
        exit(1);
    }
    printf("Data inserted successfully into table '%s'.\n", tableName);
}

// Query data from a table
void queryData(MYSQL *conn, const char *tableName) {
    char query[100];
    snprintf(query, sizeof(query), "SELECT * FROM %s", tableName);

    if (mysql_query(conn, query)) {
        fprintf(stderr, "Failed to query data from table '%s': %s\n", tableName, mysql_error(conn));
        mysql_close(conn);
        exit(1);
    }

    MYSQL_RES *result = mysql_store_result(conn);
    if (result == NULL) {
        fprintf(stderr, "mysql_store_result() failed for table '%s': %s\n", tableName, mysql_error(conn));
        mysql_close(conn);
        exit(1);
    }

    printf("Query results from table '%s':\n", tableName);
    MYSQL_ROW row;
    while ((row = mysql_fetch_row(result))) {
        printf("%s %s\n", row[0], row[1]);
    }
    mysql_free_result(result);
}

// Connect to MariaDB
MYSQL *connectToMariaDB(const char *hostname, const char *username, const char *password) {
    MYSQL *conn = mysql_init(NULL);

    if (conn == NULL) {
        fprintf(stderr, "mysql_init() failed\n");
        return NULL;
    }

    if (mysql_real_connect(conn, hostname, username, password, NULL, 0, NULL, 0) == NULL) {
        fprintf(stderr, "Failed to connect to MariaDB server at %s: %s\n", hostname, mysql_error(conn));
        mysql_close(conn);
        return NULL;
    }

    printf("Connected to MariaDB server at %s\n", hostname);
    return conn;
}

void usage (char *pgm) {
    fprintf(stderr, "Usage: %s -h hostname -u username -p password\n", pgm);
}

int main(int argc, char *argv[]) {
    int option;
    const char *hostname = NULL;
    const char *username = NULL;
    const char *password = NULL;
    const char *dbname = "testdb";
    const char *tablename = "myTable";
    char drop_query [200]; 
    while ((option = getopt(argc, argv, "h:u:p:t:")) != -1) {
        switch (option) {
            case 'h':
                hostname = optarg;
                break;
            case 'u':
                username = optarg;
                break;
            case 'p':
                password = optarg;
                break;
            default:
                usage(argv[0]);
                return 1;
        }
    }

    if (hostname == NULL || username == NULL || password == NULL) {
        usage(argv[0]);
        return 1;
    }

    MYSQL *conn = connectToMariaDB(hostname, username, password);
    if (conn == NULL) {
        return 1;
    }
    createTableAndInsertData(conn, dbname, tablename);
    queryData(conn, tablename);

    snprintf(drop_query, sizeof(drop_query), "DROP TABLE IF EXISTS %s", tablename);
    if (mysql_query(conn, drop_query)) {
        fprintf(stderr, "Failed to drop table: %s\n", mysql_error(conn));
    }
    mysql_close(conn);

    return 0;
}
