CREATE TABLE `electrocuffed_players` (
    `id` varchar(60) NOT NULL,
    `date` varchar(60) DEFAULT 0,
    `gps_status` varchar(60) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
    PRIMARY KEY (`id`)
)