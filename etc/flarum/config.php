<?php 

	/**
	 * To use this as Flarum's config file in a running container:
	 *
	 * > docker exec -d flarum mv /app/config.php_ /app/config.php
	 *
	 * The running container must provide required $_ENVs
	 */

	return array(
		'debug'    => true,
		'database' =>
			array(
				'driver'    => 'mysql',
				'host'      => $_ENV['DB_HOST'],
				'database'  => $_ENV['DB_NAME'],
				'username'  => $_ENV['DB_USER'],
				'password'  => $_ENV['DB_PASS'],
				'charset'   => 'utf8mb4',
				'collation' => 'utf8mb4_unicode_ci',
				'prefix'    => $_ENV['DB_PREFIX'],
				'strict'    => false,
			),
		'url'      => $_ENV['SITE_URL'],
		'paths'    =>
			array(
				'api'   => 'api',
				'admin' => 'admin',
			),
	);