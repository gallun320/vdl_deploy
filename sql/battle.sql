-- battle

create table Battle
(
  ID serial PRIMARY KEY, -- ID

  FirstID int DEFAULT 0 NOT NULL, -- first ID
  SecondID int DEFAULT 0 NOT NULL, -- second ID
  TurnID int DEFAULT 0 NOT NULL, -- Turn Player ID
  RoundTime int DEFAULT 30 NOT NULL, -- battle round time
  StepTime timestamp without timezone DEFAULT now() NOT NULL,
  TournamentId int DEFAULT -1 NOT NULL, -- tournament id
  Endtime timestamp without timezone DEFAULT now() NOT NULL, -- time start battle
  Avaliable boolean DEFAULT true NOT NULL,
  Finished boolean DEFAULT false NOT NULL,
  Params text DEFAULT '' NOT NULL -- parameters (Haxe)
);
