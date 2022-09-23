# Exit Obol DVT Validator



> stop main docker 

	docker compose down

> go to your charon-distributed-validator-node in my case

	cd /home/obol/charon-distributed-validator-node

	mv docker-compose.yml docker-compose.yml_bkp
	git pull

> a new docker compose is downloaded if necessary use git stash
> bring the docker up

	docker compose up -d

> let it sync for a while, then open a new window and make sure you are in 

	cd /home/obol/charon-distributed-validator-node

> there is a new file compose-voluntary-exit.yml, edit it

	nano compose-voluntary-exit.yml

> change this line image: consensys/teku:22.8.0 TO image: consensys/teku:22.9.1

> create exit_keys dir inside .charon folder and copy keystore files from validator_keys

	cd .charon/ && mkdir exit_keys

	cp validator_keys/keystore-0.* exit_keys/

> go back to charon main dir and run docker compose -f compose-voluntary-exit.yml up

	cd ..

	docker compose -f compose-voluntary-exit.yml up

> wait for the message

	Exit for validator XXXXX submitted.
>you are done 
> lighthouse version v3.1.0 is out and can be tried, above guide used v3.0.0 though.
