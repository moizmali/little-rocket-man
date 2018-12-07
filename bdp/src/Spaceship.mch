﻿/* Spaceship
 * Author: Moiz Mansoor Ali
 * Creation date: 12/4/18
 */

MACHINE Spaceship

// declaration of the properties the machine’s parameters must satisfy
// CONSTRAINTS

// declaration of deferred & enumerated sets
SETS
    GAME_STATUS = { playing , won , lost } ;
    MOVEMENT_MESSAGE = { movement_successful , movement_failed } ;
    ERROR_MESSAGE = { no_error , insufficient_power , out_of_bounds ,
                    asteroid_hit , asteroid_occupied }

// declaration of constants
CONCRETE_CONSTANTS
    space ,
    asteroids

// declaration of the properties the machine’s sets & constants must satisfy
PROPERTIES
    space : 1 .. 12 <-> 1 .. 7 &
    space : { {
                ( 1 , 1 ) , ( 1 , 2 ) , ( 1 , 3 ) , ( 1 , 4 ) , ( 1 , 5 ) , ( 1 , 6 ) , ( 1 , 7 ) ,
                ( 2 , 1 ) , ( 2 , 2 ) , ( 2 , 3 ) , ( 2 , 4 ) , ( 2 , 5 ) , ( 2 , 6 ) , ( 2 , 7 ) ,
                ( 3 , 1 ) , ( 3 , 2 ) , ( 3 , 3 ) , ( 3 , 4 ) , ( 3 , 5 ) , ( 3 , 6 ) , ( 3 , 7 ) ,
                ( 4 , 1 ) , ( 4 , 2 ) , ( 4 , 3 ) , ( 4 , 4 ) , ( 4 , 5 ) , ( 4 , 6 ) , ( 4 , 7 ) ,
                ( 5 , 1 ) , ( 5 , 2 ) , ( 5 , 3 ) , ( 5 , 4 ) , ( 5 , 5 ) , ( 5 , 6 ) , ( 5 , 7 ) ,
                ( 6 , 1 ) , ( 6 , 2 ) , ( 6 , 3 ) , ( 6 , 4 ) , ( 6 , 5 ) , ( 6 , 6 ) , ( 6 , 7 ) ,
                ( 7 , 1 ) , ( 7 , 2 ) , ( 7 , 3 ) , ( 7 , 4 ) , ( 7 , 5 ) , ( 7 , 6 ) , ( 7 , 7 ) ,
                ( 8 , 1 ) , ( 8 , 2 ) , ( 8 , 3 ) , ( 8 , 4 ) , ( 8 , 5 ) , ( 8 , 6 ) , ( 8 , 7 ) ,
                ( 9 , 1 ) , ( 9 , 2 ) , ( 9 , 3 ) , ( 9 , 4 ) , ( 9 , 5 ) , ( 9 , 6 ) , ( 9 , 7 ) ,
                ( 10 , 1 ) , ( 10 , 2 ) , ( 10 , 3 ) , ( 10 , 4 ) , ( 10 , 5 ) , ( 10 , 6 ) , ( 10 , 7 ) ,
                ( 11 , 1 ) , ( 11 , 2 ) , ( 11 , 3 ) , ( 11 , 4 ) , ( 11 , 5 ) , ( 11 , 6 ) , ( 11 , 7 ) ,
                ( 12 , 1 ) , ( 12 , 2 ) , ( 12 , 3 ) , ( 12 , 4 ) , ( 12 , 5 ) , ( 12 , 6 ) , ( 12 , 7 )
            } }
    &
    asteroids <: space &
    asteroids : { {
                    ( 7 , 1 ) , ( 3 , 2 ) , ( 11 , 2 ) , ( 8 , 3 ) , ( 5 , 4 ) , ( 3 , 5 ) ,
                    ( 7 , 5 ) , ( 12 , 5 ) , ( 10 , 6 ) , ( 6 , 7 ) , ( 7 , 7 )
                } }

// declaration of variables
ABSTRACT_VARIABLES
    //position,
    positionX ,
    positionY ,
    power ,
    asteroid_collisions ,
    game_status ,
    starbase ,

    moves_completed ,
    mission_route

// declaration of invariant properties of the variables
INVARIANT
    //position : SPACE &
    positionX : dom ( space ) &
    positionY : ran ( space ) &
    power : 0 .. 200 &
    asteroid_collisions : 0 .. 100 &
    game_status : GAME_STATUS &
    starbase : space &

    moves_completed : 1 .. 200 &
    mission_route : 1 .. 200 +-> space

// initialisation of all variables
INITIALISATION
    //position := (1 |-> 1)
    positionX := min ( dom ( space ) ) ||
    positionY := min ( ran ( space ) ) ||
    power := 200 ||
    asteroid_collisions := 0 ||
    game_status := playing ||
    starbase := ( 6 , 4 ) ||

    moves_completed := 1 ||
    mission_route := { 1 } * { ( 1 , 1 ) }

// declaration of the operations in the form of an interface (header) & body
OPERATIONS
    /*currentPosition <-- showCurrentPosition =
        BEGIN
            currentPosition := (positionX, positionY)
        END;*/

    outcome , error <-- MoveUp =
        PRE
            game_status = playing
        THEN
            IF ( positionY = max ( ran ( space ) ) ) THEN
                outcome := movement_failed ||
                error := out_of_bounds
            ELSIF ( ( positionX , positionY + 1 ) : asteroids ) THEN
                IF ( power > 10 ) THEN
                    power := power - 10 ||
                    outcome := movement_failed ||
                    error := asteroid_hit ||
                    asteroid_collisions := asteroid_collisions + 1
                ELSE
                    power := 0 ||
                    outcome := movement_failed ||
                    error := asteroid_hit ||
                    asteroid_collisions := asteroid_collisions + 1 ||
                    game_status := lost
                END
            ELSIF ( power >= 5 ) THEN
                IF ( ( positionX , positionY + 1 ) = starbase ) THEN
                    positionY := positionY + 1 ||
                    power := power - 5 ||
                    outcome := movement_successful ||
                    error := no_error ||
                    game_status := won ||

                    mission_route ( moves_completed + 1 ) := ( positionX , positionY + 1 ) ||
                    moves_completed := moves_completed + 1

                ELSIF ( power = 5 ) THEN
                    positionY := positionY + 1 ||
                    power := power - 5 ||
                    outcome := movement_successful ||
                    error := no_error ||
                    game_status := lost ||

                    mission_route ( moves_completed + 1 ) := ( positionX , positionY + 1 ) ||
                    moves_completed := moves_completed + 1

                ELSE
                    positionY := positionY + 1 ||
                    power := power - 5 ||
                    outcome := movement_successful ||
                    error := no_error ||

                    mission_route ( moves_completed + 1 ) := ( positionX , positionY + 1 ) ||
                    moves_completed := moves_completed + 1

                END
            ELSE
                power := 0 ||
                outcome := movement_failed ||
                error := insufficient_power ||
                game_status := lost
            END
        END ;

    outcome , error <-- MoveDown =
        PRE
            game_status = playing
        THEN
            IF ( positionY = min ( ran ( space ) ) ) THEN
                outcome := movement_failed ||
                error := out_of_bounds
            ELSIF ( ( positionX , positionY - 1 ) : asteroids ) THEN
                IF ( power > 10 ) THEN
                    power := power - 10 ||
                    outcome := movement_failed ||
                    error := asteroid_hit ||
                    asteroid_collisions := asteroid_collisions + 1
                ELSE
                    power := 0 ||
                    outcome := movement_failed ||
                    error := asteroid_hit ||
                    asteroid_collisions := asteroid_collisions + 1 ||
                    game_status := lost
                END
            ELSIF ( power >= 5 ) THEN
                IF ( ( positionX , positionY - 1 ) = starbase ) THEN
                    positionY := positionY - 1 ||
                    power := power - 5 ||
                    outcome := movement_successful ||
                    error := no_error ||
                    game_status := won ||

                    mission_route ( moves_completed + 1 ) := ( positionX , positionY - 1 ) ||
                    moves_completed := moves_completed + 1

                ELSIF ( power = 5 ) THEN
                    positionY := positionY - 1 ||
                    power := power - 5 ||
                    outcome := movement_successful ||
                    error := no_error ||
                    game_status := lost ||

                    mission_route ( moves_completed + 1 ) := ( positionX , positionY - 1 ) ||
                    moves_completed := moves_completed + 1

                ELSE
                    positionY := positionY - 1 ||
                    power := power - 5 ||
                    outcome := movement_successful ||
                    error := no_error ||

                    mission_route ( moves_completed + 1 ) := ( positionX , positionY - 1 ) ||
                    moves_completed := moves_completed + 1

                END
            ELSE
                power := 0 ||
                outcome := movement_failed ||
                error := insufficient_power ||
                game_status := lost
            END
        END ;

    outcome , error <-- MoveForward =
        PRE
            game_status = playing
        THEN
            IF ( positionX = max ( dom ( space ) ) ) THEN
                outcome := movement_failed ||
                error := out_of_bounds
            ELSIF ( ( positionX + 1 , positionY ) : asteroids ) THEN
                IF ( power > 10 ) THEN
                    power := power - 10 ||
                    outcome := movement_failed ||
                    error := asteroid_hit ||
                    asteroid_collisions := asteroid_collisions + 1
                ELSE
                    power := 0 ||
                    outcome := movement_failed ||
                    error := asteroid_hit ||
                    asteroid_collisions := asteroid_collisions + 1 ||
                    game_status := lost
                END
            ELSIF ( power >= 5 ) THEN
                IF ( ( positionX + 1 , positionY ) = starbase ) THEN
                    positionX := positionX + 1 ||
                    power := power - 5 ||
                    outcome := movement_successful ||
                    error := no_error ||
                    game_status := won ||

                    mission_route ( moves_completed + 1 ) := ( positionX + 1 , positionY ) ||
                    moves_completed := moves_completed + 1

                ELSIF ( power = 5 ) THEN
                    positionX := positionX + 1 ||
                    power := power - 5 ||
                    outcome := movement_successful ||
                    error := no_error ||
                    game_status := lost ||

                    mission_route ( moves_completed + 1 ) := ( positionX + 1 , positionY ) ||
                    moves_completed := moves_completed + 1

                ELSE
                    positionX := positionX + 1 ||
                    power := power - 5 ||
                    outcome := movement_successful ||
                    error := no_error ||

                    mission_route ( moves_completed + 1 ) := ( positionX + 1 , positionY ) ||
                    moves_completed := moves_completed + 1

                END
            ELSE
                power := 0 ||
                outcome := movement_failed ||
                error := insufficient_power ||
                game_status := lost
            END
        END ;

    outcome , error <-- MoveBackward =
        PRE
            game_status = playing
        THEN
            IF ( positionX = min ( dom ( space ) ) ) THEN
                outcome := movement_failed ||
                error := out_of_bounds
            ELSIF ( ( positionX - 1 , positionY ) : asteroids ) THEN
                IF ( power > 10 ) THEN
                    power := power - 10 ||
                    outcome := movement_failed ||
                    error := asteroid_hit ||
                    asteroid_collisions := asteroid_collisions + 1
                ELSE
                    power := 0 ||
                    outcome := movement_failed ||
                    error := asteroid_hit ||
                    asteroid_collisions := asteroid_collisions + 1 ||
                    game_status := lost
                END
            ELSIF ( power >= 5 ) THEN
                IF ( ( positionX - 1 , positionY ) = starbase ) THEN
                    positionX := positionX - 1 ||
                    power := power - 5 ||
                    outcome := movement_successful ||
                    error := no_error ||
                    game_status := won ||

                    mission_route ( moves_completed + 1 ) := ( positionX - 1 , positionY ) ||
                    moves_completed := moves_completed + 1

                ELSIF ( power = 5 ) THEN
                    positionX := positionX - 1 ||
                    power := power - 5 ||
                    outcome := movement_successful ||
                    error := no_error ||
                    game_status := lost ||

                    mission_route ( moves_completed + 1 ) := ( positionX - 1 , positionY ) ||
                    moves_completed := moves_completed + 1

                ELSE
                    positionX := positionX - 1 ||
                    power := power - 5 ||
                    outcome := movement_successful ||
                    error := no_error ||

                    mission_route ( moves_completed + 1 ) := ( positionX - 1 , positionY ) ||
                    moves_completed := moves_completed + 1

                END
            ELSE
                power := 0 ||
                outcome := movement_failed ||
                error := insufficient_power ||
                game_status := lost
            END
        END ;

    outcome , error <-- EngageWarpDrive ( xx , yy ) =
        PRE
            game_status = playing &
            xx : dom ( space ) &
            yy : ran ( space ) &
            ( xx , yy ) /= starbase
        THEN
            IF ( power > 20 ) THEN
                IF ( ( xx , yy ) : asteroids ) THEN
                    outcome := movement_failed ||
                    error := asteroid_occupied
                ELSE
                    power := power - 20 ||
                    positionX := xx ||
                    positionY := yy ||
                    outcome := movement_successful ||
                    error := no_error ||

                    mission_route ( moves_completed + 1 ) := ( xx , yy ) ||
                    moves_completed := moves_completed + 1

                END
            ELSE
                outcome := movement_failed ||
                error := insufficient_power
            END
        END ;

    currentLocation , currentPower , asteroidCollisions <-- MissionStatus =
        BEGIN
            currentLocation := ( positionX , positionY ) ||
            currentPower := power ||
            asteroidCollisions := asteroid_collisions
        END ;

    missionRoute <-- MissionRoute =
        BEGIN
            missionRoute := mission_route
        END ;

    answer <-- DockedAtStarbase =
        BEGIN
            IF ( ( positionX , positionY ) = starbase ) THEN
                answer := TRUE
            ELSE
                answer := FALSE
            END
        END ;

    gameStatus <-- GameStatus =
        BEGIN
            gameStatus := game_status
        END

END