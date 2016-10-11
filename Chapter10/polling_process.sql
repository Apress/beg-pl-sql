-- Turn the debug log on for this program unit so I can use
-- it to show that this routine actually works.
--execute DEBUG_TS.enable('POLLING_PROCESS');

execute POLLING_PROCESS.process;
