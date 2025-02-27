module CofreeBot.Bot.Simple where

import CofreeBot.Bot ( BotAction(..), Bot(..) )
import Data.Foldable ( traverse_ )
import Data.Text qualified as T
import System.IO ( stdout, hFlush )

-- | A 'SimpleBot' maps from 'Text' to '[Text]'. Lifting into a
-- 'SimpleBot' is useful for locally debugging another bot.
type TextBot m s = Bot m s T.Text [T.Text]

-- | An evaluator for running 'SimpleBots' in 'IO'
runSimpleBot :: forall s. TextBot IO s -> s -> IO ()
runSimpleBot bot = go
  where
  go :: s -> IO ()
  go state = do
    putStr "<<< "
    hFlush stdout
    input <- getLine
    BotAction {..} <- runBot bot (T.pack input) state
    traverse_ (putStrLn . T.unpack . (">>> " <>)) responses
    go nextState
