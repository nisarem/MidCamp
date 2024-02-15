USE Velib;

ALTER TABLE availability ADD PRIMARY KEY (ID);
ALTER TABLE availability CHANGE COLUMN ID station_ID INT NOT NULL;
RENAME TABLE availability TO stations;

ALTER TABLE durations ADD COLUMN duration_id INT AUTO_INCREMENT PRIMARY KEY FIRST;
CREATE TEMPORARY TABLE temp_durations AS
SELECT
    @row_number := @row_number + 1 AS new_duration_id,
    old.*
FROM
    durations old,
    (SELECT @row_number := 0) AS r;
ALTER TABLE durations CHANGE COLUMN ID station_ID INT NOT NULL;

UPDATE durations
JOIN temp_durations ON durations.ID = temp_durations.ID
SET durations.duration_id = temp_durations.new_duration_id;
ALTER TABLE logs CHANGE COLUMN ID station_ID INT NOT NULL;


ALTER TABLE durations
ADD CONSTRAINT fk_durations_station_id
FOREIGN KEY (station_ID) REFERENCES stations(station_ID);

ALTER TABLE logs
ADD CONSTRAINT fk_logs_station_id
FOREIGN KEY (station_ID) REFERENCES stations(station_ID);

SELECT * FROM durations;
SELECT * FROM logs;
SELECT * FROM stations;