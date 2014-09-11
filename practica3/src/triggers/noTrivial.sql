-- Trigger 1
-- Calcula el numero de desvios totales que tiene cada aeropuert

ALTER TABLE aeropuertoDeEEUU
ADD desvios NUMBER(5) DEFAULT 0 NOT NULL;

CREATE OR REPLACE TRIGGER DesviosAeropuerto 
	BEFORE INSERT OR UPDATE ON esDesvio	        		
	FOR EACH ROW
	BEGIN 	
		FOR rec IN ( SELECT count(*) as num, iata FROM esDesvio GROUP BY iata) 
		LOOP
			UPDATE aeropuertoDeEEUU SET average = (rec.num) WHERE (iata=rec.iata) ;
		END LOOP;	
	END;

-- Trigger 2
-- Calcula diferencia de tiempo wheelsOn wheelsOff de un Vuelo
stmt.execute("ALTER TABLE Vuelo
ADD tiempo NUMBER (4) DEFAULT 0 NOT NULL

CREATE OR REPLACE TRIGGER auxiliarMutante 
	AFTER INSERT OR UPDATE OF wheelsOn, wheelsOff ON Vuelo 
	FOR EACH ROW 
	BEGIN  
		INSERT INTO tmpVuelo(id,desvioNum,wheelsOn,wheelsOff) VALUES (:NEW.id, :NEW.desvioNum, :NEW.wheelsOn, :NEW.wheelsOff); 
END;

CREATE OR REPLACE TRIGGER difOnOff 
	AFTER INSERT OR UPDATE OF wheelsOn,wheelsOff ON Vuelo  
BEGIN  
	FOR rec IN (SELECT * from tmpVuelo)  
	LOOP  
		IF ((rec.wheelsOn-rec.wheelsOff) < 0) THEN  
			UPDATE Vuelo SET tiempo=(2400(rec.wheelsOn-rec.wheelsOff)) WHERE (id=rec.id) AND (desvioNum=rec.desvioNum); 
		ELSE  
			UPDATE Vuelo SET tiempo=(rec.wheelsOn-rec.wheelsOff) WHERE (id=rec.id) AND (desvioNum=rec.desvioNum);  
		END IF; 
	END LOOP;
	DELETE FROM tmpVuelo;  	 
END;     		

--pruebas
insert into vuelo (wheelsOn, wheelsOff, desvioNum, id) values (1256, 1356, 3,43950)
--insert into esDesvio (iata,desvionum,id) values ('SFO',3,43950)
select * from user_errors where type = 'TRIGGER'



