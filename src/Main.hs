module Main where

import Scenes
import Types (Scene, asciiArt, description, options)
import System.Console.ANSI
import System.IO

main :: IO ()
main = do
    hSetBuffering stdout NoBuffering -- Da bismo odmah videli ispis

    -- Učitavanje početne scene
    startScene <- readScene "scene1"
    displayScene startScene

displayScene :: Scene -> IO ()
displayScene scene = do
    clearScreen
    setCursorPosition 0 0
    putStrLn (asciiArt scene)
    putStrLn ""
    putStrLn (description scene)
    putStrLn ""
    putStrLn "Options:"
    mapM_ (\(idx, (opt, _)) -> putStrLn (show idx ++ ". " ++ opt)) (zip [1..] (options scene))
    choice <- getChoice (length (options scene))
    let nextSceneFile = snd (options scene !! (choice - 1))
    nextScene <- readScene nextSceneFile
    displayScene nextScene

getChoice :: Int -> IO Int
getChoice numOptions = do
    putStr "Enter your choice: "
    choiceStr <- getLine
    let choice = read choiceStr
    if choice < 1 || choice > numOptions
        then do
            putStrLn "Invalid choice. Please try again."
            getChoice numOptions
        else return choice
