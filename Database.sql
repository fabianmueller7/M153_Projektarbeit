CREATE TABLE `Spieler`(
    `id` INT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY,
    `Vorname` VARCHAR(255) NOT NULL,
    `Nachname` VARCHAR(255) NOT NULL,
    `Geburtsdatum` DATE NOT NULL,
    `Position` VARCHAR(255) NOT NULL,
    `Nationalität` VARCHAR(255) NOT NULL
);
CREATE TABLE `Fifa Ranking`(
    `id` INT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY,
    `Fifa Version` VARCHAR(255) NOT NULL,
    `Gesamt Rating` INT NOT NULL,
    `Pace Rating` INT NOT NULL,
    `Shoot Rating` INT NOT NULL,
    `Pasing Rating` INT NOT NULL,
    `Dribbling Rating` INT NOT NULL,
    `Defensive Rating` INT NOT NULL,
    `Physis Rating` INT NOT NULL
);
CREATE TABLE `Mannschaft`(
    `id` INT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY,
    `Klubname` VARCHAR(255) NOT NULL,
    `Klubkürzel` VARCHAR(255) NOT NULL,
    `Sponsor` VARCHAR(255) NOT NULL,
    `fk_CoachID` INT NOT NULL
);
CREATE TABLE `Coach`(
    `id` INT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY,
    `Vorname` VARCHAR(255) NOT NULL,
    `Nachname` VARCHAR(255) NOT NULL
);
CREATE TABLE `spielt`(
    `id` INT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY,
    `von` DATE NOT NULL,
    `bis` DATE NOT NULL,
    `gesperrt` TINYINT(1) NOT NULL,
    `Lohn` DOUBLE(8, 2) NOT NULL,
    `fk_SpielerID` INT NOT NULL,
    `fk_MannschaftID` INT NOT NULL
);
CREATE TABLE `besitzt`(
    `id` INT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY,
    `fk_FifaRankingID` INT NOT NULL,
    `fk_SpielerID` INT NOT NULL
);
ALTER TABLE
    `besitzt` ADD CONSTRAINT `besitzt_fk_spielerid_foreign` FOREIGN KEY(`fk_SpielerID`) REFERENCES `Spieler`(`id`);
ALTER TABLE
    `spielt` ADD CONSTRAINT `spielt_fk_spielerid_foreign` FOREIGN KEY(`fk_SpielerID`) REFERENCES `Spieler`(`id`);
ALTER TABLE
    `Mannschaft` ADD CONSTRAINT `mannschaft_fk_coachid_foreign` FOREIGN KEY(`fk_CoachID`) REFERENCES `Coach`(`id`);
ALTER TABLE
    `besitzt` ADD CONSTRAINT `besitzt_fk_fifarankingid_foreign` FOREIGN KEY(`fk_FifaRankingID`) REFERENCES `Fifa Ranking`(`id`);
ALTER TABLE
    `spielt` ADD CONSTRAINT `spielt_fk_mannschaftid_foreign` FOREIGN KEY(`fk_MannschaftID`) REFERENCES `Mannschaft`(`id`);