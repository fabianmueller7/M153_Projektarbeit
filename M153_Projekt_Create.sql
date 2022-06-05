﻿use master
go
drop database if exists Fussballspieler
go
create database Fussballspieler
go
use Fussballspieler
go

CREATE TABLE Spieler(
    id INT   identity PRIMARY KEY,
    Vorname VARCHAR(255) ,
    Nachname VARCHAR(255) ,
    Geburtsdatum DATE ,
    Position VARCHAR(255) ,
    Nationalität VARCHAR(255) 
);
CREATE TABLE "Fifa Ranking"(
    id INT   identity PRIMARY KEY,
    "Fifa Version" VARCHAR(255) ,
    "Gesamt Rating" INT ,
    "Pace Rating" INT ,
    "Shoot Rating" INT ,
    "Pasing Rating" INT ,
    "Dribbling Rating" INT ,
    "Defensive Rating" INT ,
    "Physis Rating" INT ,
    fk_SpielerID INT 
);
CREATE TABLE Mannschaft(
    id INT   identity PRIMARY KEY,
    Klubname VARCHAR(255) ,
    Klubkürzel VARCHAR(255) ,
    Sponsor VARCHAR(255) ,
    fk_CoachID INT 
);
CREATE TABLE Coach(
    id INT   identity PRIMARY KEY,
    Vorname VARCHAR(255) ,
    Nachname VARCHAR(255) 
);
CREATE TABLE spielt(
    id INT   identity PRIMARY KEY,
    von DATE ,
    bis DATE ,
    gesperrt BIT ,
    Lohn FLOAT ,
    fk_SpielerID INT ,
    fk_MannschaftID INT 
);
ALTER TABLE
    "Fifa Ranking" ADD CONSTRAINT fifa_ranking_fk_spielerid_foreign FOREIGN KEY(fk_SpielerID) REFERENCES Spieler(id);
ALTER TABLE
    spielt ADD CONSTRAINT spielt_fk_spielerid_foreign FOREIGN KEY(fk_SpielerID) REFERENCES Spieler(id);
ALTER TABLE
    Mannschaft ADD CONSTRAINT mannschaft_fk_coachid_foreign FOREIGN KEY(fk_CoachID) REFERENCES Coach(id);
ALTER TABLE
    spielt ADD CONSTRAINT spielt_fk_mannschaftid_foreign FOREIGN KEY(fk_MannschaftID) REFERENCES Mannschaft(id);
GO

Create Trigger OnMannschaftdelete on Mannschaft AFTER delete as
begin
	Update spielt Set spielt.bis = CURRENT_TIMESTAMP, spielt.fk_MannschaftID = NULL Where spielt.fk_MannschaftID = (select id from deleted) AND spielt.bis > CURRENT_TIMESTAMP
end
GO

Create Procedure sp_AnzSpieler
	@KlubkürzelBez varchar(50)= NULL
AS BEGIN
	DECLARE @AnzSpieler INT = 0;
	SET @AnzSpieler = (Select COUNT(spielt.fk_SpielerID) from Mannschaft join spielt on spielt.fk_MannschaftID = Mannschaft.id Where spielt.bis > CURRENT_TIMESTAMP and Mannschaft.Klubkürzel = @KlubkürzelBez);
	RETURN @AnzSpieler;
END
GO

Create Procedure sp_UpsertFifaRanking
	@Vorname varchar(50)= NULL,
	@Nachname varchar(50)= NULL,
	@Gebdatum date = NULL,
	@FifaVersion varchar(50)= NULL,
	@GesamtRating INT = 0,
	@PaceRating INT = 0,
	@ShootRating INT = 0,
	@PasingRating INT = 0,
	@DribblingRating INT = 0,
	@DefensiveRating INT = 0,
	@PhysisRating INT = 0
AS BEGIN
	if((Select COUNT([Fifa Ranking].fk_SpielerID) From [Fifa Ranking] join Spieler on Spieler.id = [Fifa Ranking].fk_SpielerID where Vorname = @Vorname and Nachname = @Nachname and Geburtsdatum = @Gebdatum and [Fifa Ranking].[Fifa Version] = @FifaVersion) = 0) BEGIN
		INSERT INTO [Fifa Ranking] ("Fifa Version", "Gesamt Rating", "Pace Rating", "Shoot Rating", "Pasing Rating", "Dribbling Rating", "Defensive Rating", "Physis Rating", "fk_SpielerID")
		Values (@FifaVersion, @GesamtRating, @PaceRating, @ShootRating, @PasingRating, @DribblingRating, @DefensiveRating, @PhysisRating, (Select id from Spieler Where Vorname = @Vorname and Nachname = @Nachname and Geburtsdatum = @Gebdatum));
		PRINT 'Ranking hinzugefügt'
	END ELSE BEGIN
		Update [Fifa Ranking] SET "Fifa Version" = @FifaVersion, "Gesamt Rating" = @GesamtRating, "Pace Rating" = @PaceRating, "Shoot Rating" = @ShootRating, "Pasing Rating" = @PasingRating, "Dribbling Rating" = @DribblingRating, "Defensive Rating" =  @DefensiveRating, "Physis Rating" = @PhysisRating
		where [Fifa Ranking].fk_SpielerID = (Select id From Spieler where Vorname = @Vorname and Nachname = @Nachname and Geburtsdatum = @Gebdatum) and [Fifa Ranking].[Fifa Version] = @FifaVersion;
		Print 'Ranking akktualisiert'
	END
END
GO

