import Control.Monad (forM)
import Development.Shake
import Development.Shake.Command
import Development.Shake.FilePath
import Development.Shake.Util

main :: IO ()
main = shakeArgs shakeOptions{shakeFiles="_build"} $ do
    want ["_build/hydra-spec" <.> "pdf"]

    phony "clean" $ do
      putInfo "Cleaning files in _build"
      removeFilesAfter "_build" ["//*"]

    "_build/hydra-spec" <.> "pdf" %> \out -> do
      assets <- getDirectoryFiles "src" ["//*.sty", "//*.pdf", "//*.bib", "//*.ttf", "//*.typ"]
      need ["_build/src" </> c | c <- assets]
      cmd_ $ "typst compile --root _build _build/src/Hydra/Protocol/Main.lagda.typ " <> out

    forM ["typ", "sty", "pdf", "bib", "ttf"] $ \ext ->
      ("_build//*." <> ext)  %> \out -> do
        let src = "src" </> dropDirectory1 (dropDirectory1 out)
        copyFile' src out

    phony "check" $ do
      cmd_ $ "agda src/Hydra/Protocol/Main.lagda.typ" 
