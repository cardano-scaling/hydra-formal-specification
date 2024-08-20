import Development.Shake
import Development.Shake.Command
import Development.Shake.FilePath
import Development.Shake.Util

main :: IO ()
main = shakeArgs shakeOptions{shakeFiles="_build"} $ do
    want ["hydra-spec" <.> "pdf"]

    phony "clean" $ do
      putInfo "Cleaning files in _build"
      removeFilesAfter "_build" ["//*"]

    "hydra-spec" <.> "pdf" %> \out -> do
      -- lagdas <- getDirectoryFiles "" ["//*.lagda"]
      -- let texs = ["latex" </> c -<.> "tex" | c <- lagdas]
      texs <- getDirectoryFiles "hydra-protocol" ["//*.tex"]
      let dsts = ["latex" </> d | d <- texs]
      need dsts
      -- cmd_ "find latex"
      cmd_ "latexmk -xelatex latex/Hydra/Protocol/Overview.tex"
      -- copyFile "Main.pdf" "_build/hydra-protocol.pdf"

    "latex//*.tex"  %> \out -> do
      let src = "hydra-protocol" </> dropDirectory1 out
      need [src]
      copyFile' src out
