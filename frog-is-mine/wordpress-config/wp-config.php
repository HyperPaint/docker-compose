<?php
/**
 * Основные параметры WordPress.
 *
 * Скрипт для создания wp-config.php использует этот файл в процессе установки.
 * Необязательно использовать веб-интерфейс, можно скопировать файл в "wp-config.php"
 * и заполнить значения вручную.
 *
 * Этот файл содержит следующие параметры:
 *
 * * Настройки базы данных
 * * Секретные ключи
 * * Префикс таблиц базы данных
 * * ABSPATH
 *
 * @link https://ru.wordpress.org/support/article/editing-wp-config-php/
 *
 * @package WordPress
 */

// ** Параметры базы данных: Эту информацию можно получить у вашего хостинг-провайдера ** //
/** Имя базы данных для WordPress */
define( 'DB_NAME', 'wordpress' );

/** Имя пользователя базы данных */
define( 'DB_USER', 'root' );

/** Пароль к базе данных */
define( 'DB_PASSWORD', 'password' );

/** Имя сервера базы данных */
define( 'DB_HOST', 'database.shared-default' );

/** Кодировка базы данных для создания таблиц. */
define( 'DB_CHARSET', 'utf8mb4' );

/** Схема сопоставления. Не меняйте, если не уверены. */
define( 'DB_COLLATE', '' );

/**#@+
 * Уникальные ключи и соли для аутентификации.
 *
 * Смените значение каждой константы на уникальную фразу. Можно сгенерировать их с помощью
 * {@link https://api.wordpress.org/secret-key/1.1/salt/ сервиса ключей на WordPress.org}.
 *
 * Можно изменить их, чтобы сделать существующие файлы cookies недействительными.
 * Пользователям потребуется авторизоваться снова.
 *
 * @since 2.6.0
 */
define( 'AUTH_KEY',         'yz@#Myq-HdUeA9P2/-24qdmjjx2[0kGhn7`L-ul!:D[$NldFs&2)KSdDk2WT(%SV' );
define( 'SECURE_AUTH_KEY',  '5~c?L/vLcDIv[I5j@J_6*T]~pNWy%R<~Zzl>-^7}5.(zzppNep ubCR1bA-/^Bg6' );
define( 'LOGGED_IN_KEY',    'roT*!T6cXuzj*KIq7/{aB$x~G;Pb.rWlc*>5-.:>.9{!oy#)ip?:-[q%e:ei&%Qv' );
define( 'NONCE_KEY',        'b~kuW}IRCEBL[`AY^h(?DSxzN^*$srkyrmKK,]RDpbn?Q!,Lf!{Pq)hhFJN(3bR*' );
define( 'AUTH_SALT',        '6LUoaZEm~~(, Pt2u4no0;Qr70:-fACqrf#3uTF|)`z4R}04rOLpZXdellaD^U~&' );
define( 'SECURE_AUTH_SALT', '1Y;i;I1{.0-`+q|,}u_name;#_b{3Y!L#&u_8c%Iao)+Tm([aq^%+WLRt3IID=/?' );
define( 'LOGGED_IN_SALT',   'a{nI)r30% fYyy@5r&mzoS0z48$0~^Kz@uEZhW^KWco<c~{<0ZFgeKm6!,K?OG[n' );
define( 'NONCE_SALT',       'D@1M{]#kV.pVwxX< 7X;:t8p-g0b>;i/$+jOpDX@ b901Hv?LZ>[;jLc3%nzNg3B' );

/**#@-*/

/**
 * Префикс таблиц в базе данных WordPress.
 *
 * Можно установить несколько сайтов в одну базу данных, если использовать
 * разные префиксы. Пожалуйста, указывайте только цифры, буквы и знак подчеркивания.
 */
$table_prefix = 'wp_';

/**
 * Для разработчиков: Режим отладки WordPress.
 *
 * Измените это значение на true, чтобы включить отображение уведомлений при разработке.
 * Разработчикам плагинов и тем настоятельно рекомендуется использовать WP_DEBUG
 * в своём рабочем окружении.
 *
 * Информацию о других отладочных константах можно найти в документации.
 *
 * @link https://ru.wordpress.org/support/article/debugging-in-wordpress/
 */
define( 'WP_DEBUG', false );

/* Произвольные значения добавляйте между этой строкой и надписью "дальше не редактируем". */

define( 'FS_METHOD', 'direct' );
define( 'WP_AUTO_UPDATE_CORE', false );


# HTTPS
$_SERVER['REQUEST_SCHEME'] = 'https';
$_SERVER['HTTPS'] = 'on';

# Директория
define( 'WP_HOME', '/blog' );
define( 'WP_SITEURL', '/blog' );
# Дашборд
$count = 1;
$_SERVER['REQUEST_URI'] = str_replace('/wp-admin/', '/blog/wp-admin/', $_SERVER['REQUEST_URI'], $count);

/* Это всё, дальше не редактируем. Успехов! */

/** Абсолютный путь к директории WordPress. */
if ( ! defined( 'ABSPATH' ) ) {
	define( 'ABSPATH', __DIR__ . '/' );
}

/** Инициализирует переменные WordPress и подключает файлы. */
require_once ABSPATH . 'wp-settings.php';
