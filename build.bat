@echo off

set ROOT_DIR=%~dp0
set SOURCE_DIR=%ROOT_DIR%src
set BUILD_DIR=%ROOT_DIR%build

set LATEX_RUN=pdflatex -interaction=nonstopmode -file-line-error -synctex=1 -output-directory=%BUILD_DIR% main.tex
set BIBTEX_RUN=bibtex main.aux

if exist %BUILD_DIR% dir /a-d "%BUILD_DIR%" >nul 2>nul && (
		
	@rem If there are cached files from previous compilations, reuse those.
	echo.
	echo *** Recompiling ***
	cd "%SOURCE_DIR%"
	%LATEX_RUN% >nul
	findstr /c:"LaTeX Warning" /c:"LaTeX Error" "%BUILD_DIR%\main.log" > "%BUILD_DIR%\main.log.tmp" && (
		type "%BUILD_DIR%\main.log.tmp"
	) || (
		echo Finished without warnings or errors.
	)
	goto end

)

mkdir "%BUILD_DIR%"
@rem Compile for the first time and generate AUX files for BibTeX.
echo.
echo *** Compiling for the first time ***
cd "%SOURCE_DIR%"
%LATEX_RUN% >nul
findstr /c:"LaTeX Warning" /c:"LaTeX Error" "%BUILD_DIR%\main.log" > "%BUILD_DIR%\main.log.tmp" && (
	type "%BUILD_DIR%\main.log.tmp"
) || (
	echo Finished without warnings or errors.
)

@rem Generate bibliography from the generated AUX file.
echo.
echo *** Generating bibliography ***
cd "%BUILD_DIR%"
copy "%SOURCE_DIR%\sources.bib" . >nul 2>nul
%BIBTEX_RUN%

@rem Compile three times. First to include the generated BBL file, second to take the included bibliography into account
@rem (page numbers, ...) and a third time to get possibly changed labels and cross-references right.
echo.
echo *** Compiling for the second time ***
cd "%SOURCE_DIR%"
%LATEX_RUN% >nul
%LATEX_RUN% >nul
%LATEX_RUN% >nul
findstr /c:"LaTeX Warning" /c:"LaTeX Error" "%BUILD_DIR%\main.log" > "%BUILD_DIR%\main.log.tmp" && (
	type "%BUILD_DIR%\main.log.tmp"
) || (
	echo Finished without warnings or errors.
)

:end
cd %ROOT_DIR%