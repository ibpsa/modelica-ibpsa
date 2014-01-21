%
% LaTeX PhD class
%
% Maarten De Munck
%
 
\NeedsTeXFormat{LaTeX2e}[1998/12/01]
\ProvidesClass{phd}[2008/05/05 Maarten's PhD class]

\LoadClass[a4paper,10pt,twoside,onecolumn,final,openright,titlepage]{book}

\ProcessOptions\relax

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% Language

\RequirePackage[dutch,english]{babel}
\selectlanguage{english}

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% Page setup
%

% Page size
\RequirePackage{geometry}
\geometry{papersize={16cm,24cm},inner=15mm,top=35mm,outer=25mm,bottom=25mm,headsep=24pt,headheight=24pt}
%top=22, bottom=22
%headsep=14
% Headers and footers
\RequirePackage{fancyhdr}
\pagestyle{fancy}
\renewcommand{\chaptermark}[1]{\markboth{#1}{}}
\renewcommand{\sectionmark}[1]{\markright{#1}}
\fancyhf{}
\fancyhead[LE]{{\normalsize\textbf{\thepage}\quad\textbar\quad}\nouppercase{\leftmark}}
\fancyhead[RO]{\nouppercase{\rightmark}{\quad\textbar\quad\normalsize\textbf{\thepage}}}

\renewcommand{\headrulewidth}{0pt}
\fancypagestyle{plain}{%
	\fancyhf{}
	\renewcommand{\headrulewidth}{0pt}
}

% No headers or footers on empty pages
\makeatletter 
\def\cleardoublepage{\clearpage\if@twoside \ifodd\c@page\else 
	\hbox{}
	\vspace*{\fill}
	\thispagestyle{empty} 
	\newpage 
	\if@twocolumn\hbox{}\newpage\fi\fi\fi} 
\makeatother

% Paragraphs
\setlength{\parindent}{0pt}
\setlength{\parskip}{4pt plus 2pt minus 1pt}

% ToC, LoF, LoT
\usepackage{tocvsec2}

\usepackage[subfigure]{tocloft} % subfigure option only if using subfigure package


\renewcommand{\cfttoctitlefont} % ToC title
             {\usefont{T1}{bch}{b}{n}\selectfont\huge}

\renewcommand{\cftchapfont} % chapter titles
             {\usefont{T1}{bch}{b}{n}\selectfont}
%lmss %lmr
\renewcommand{\cftsecfont} % section titles
             {\usefont{T1}{bch}{m}{n}\selectfont}
\renewcommand{\cftsubsecfont} % subsection titles
             {\usefont{T1}{bch}{m}{n}\selectfont} 
\renewcommand{\cftchappagefont} % chapter page numbers
             {\usefont{T1}{bch}{b}{n}\selectfont}
\renewcommand{\cftsecpagefont} % section page numbers
             {\cftsecfont} 
\renewcommand{\cftsubsecpagefont} % subsection page numbers
             {\cftsubsecfont}

\renewcommand{\cftdotsep}{1.5}
\renewcommand{\cftchapleader}{\cftdotfill{\cftdotsep}}

\makeatletter
\newcommand*\l@chapterinfo{\@nodottedtocline{0}{0.0em}{1.5em}}
\def\@nodottedtocline#1#2#3#4#5{%
  \ifnum #1>\c@tocdepth \else
    \vskip \z@ \@plus.2\p@
    {\leftskip #2\relax \rightskip \@tocrmarg \parfillskip -\rightskip
     \parindent #2\relax\@afterindenttrue
     \interlinepenalty\@M
     \leavevmode
     \@tempdima #3\relax
     \advance\leftskip \@tempdima \null\nobreak\hskip -\leftskip
     {#4}\nobreak
     \leaders\hbox{$\m@th
        \mkern \@dotsep mu\hbox{\,}\mkern \@dotsep
        mu$}\hfill
     \nobreak
     \hb@xt@\@pnumwidth{\hfil\normalfont \normalcolor }%
     \par}%
  \fi}
\makeatother

\def\chapterinfo#1{%
    \addcontentsline{toc}{chapterinfo}{%
    \noexpand\numberline{}\textit{#1}}%
}

\renewcommand{\normalsize}{\small}

\tocloftpagestyle{plain}
\usepackage[section]{tocbibind}
\cftsetpnumwidth{1.75em}
\cftsetrmarg{1.85em} 

\renewcommand\cftpartfont{\large\sc}

% Lists
\usepackage{enumitem}

\sloppy


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% Mathematics
%

\usepackage{amsfonts}
\usepackage[fleqn]{amsmath}
\usepackage{amssymb}

% \setlength{\arraycolsep}{2pt} % reduce the distance between the columns of an array
\newcommand{\eqnref}[1]{(\ref{#1})}

\newtheorem{theorem}{Theorem}[chapter]


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% Grahics, figures and tables
%

\usepackage{color}
\usepackage[final,pdftex]{graphicx}
\usepackage{rotating}
\usepackage{tikz}
\usetikzlibrary{shapes}
\usetikzlibrary{patterns}
% \usepackage{pict2e}
\usepackage[center]{subfigure}

\usepackage{supertabular}
\usepackage{colortbl}
\usepackage{hhline}
\usepackage{multirow}

\usepackage{caption}
\captionsetup{labelformat=simple,labelsep=colon,justification=justified,singlelinecheck=true,font=small,labelfont=bf}
% \captionsetup{format=hang,labelformat=simple,labelsep=colon,justification=justified,singlelinecheck=true,font=small,labelfont=bf}
\setlength{\abovecaptionskip}{8pt plus 2pt}

\usepackage{listings}
\renewcommand\lstlistlistingname{List of Listings}


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% Bibliography
%

\usepackage[super, longnamesfirst, sort&compress]{natbib}
% vertical spacing in the bibliography
\setlength{\bibsep}{0.0pt}


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% Hyperref setup
%

\RequirePackage[final,pagebackref]{hyperref}
\hypersetup{colorlinks=false, pdfborder={0 0 0}}
\hypersetup{pdfpagemode=UseOutlines,pdfstartpage=1,pdfstartview  = FitV,plainpages=false}

\renewcommand*{\backref}[1]{
	% default interface
	% #1: backref list
}


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% Other stuff
%

% \usepackage{bbding}
% \usepackage{textcomp}
\usepackage{textpos}
\definecolor{gray}{rgb}{0.600,0.600,0.600}
\setlength{\TPHorizModule}{1mm}
\setlength{\TPVertModule}{1mm}

% FONT
\usepackage[T1]{fontenc}
\usepackage{lmodern}
%\linespread{1.1}

% SI Units
\usepackage[squaren]{SIunits}

% Title sections
\usepackage{titlesec}

\titleformat{\part}[display]{\normalfont\LARGE\centering}{\thepart}{0pt}{\LARGE\textsc}
\titleformat{\chapter}[display]{\normalfont\Large}{\chaptertitlename\ \thechapter}{0pt}{\LARGE\textsc}
\titlespacing*{\chapter}{0pt}{10pt}{100pt}

\titleformat{\section}[hang]{\normalfont\large}{\thesection\ }{1pt}{\large\textbf}
\titleformat{\subsection}[hang]{\normalfont\large}{\thesubsection\ }{1pt}{\large}

\titleformat{\subsubsection}[display]{\normalfont\normalsize}{}{0pt}{\normalsize\textbf}
\titlespacing*{\subsubsection}{0pt}{0pt}{0pt}

\titleformat{\paragraph}[runin]{\normalfont\normalsize}{}{0pt}{\normalsize\textit}[.]
\titlespacing*{\paragraph}{0pt}{0pt}{4pt}

\makeatletter
\g@addto@macro\normalsize{%
  \setlength\abovedisplayskip{0pt}
  \setlength\belowdisplayskip{5pt plus 2pt minus 1pt}
  \setlength\abovedisplayshortskip{0pt}
  \setlength\belowdisplayshortskip{5pt plus 2pt minus 1pt}
}


\usepackage[activate={true,nocompatibility},final,tracking=true,kerning=true,spacing=true,factor=1100,stretch=10,shrink=10]{microtype}
\SetTracking{encoding={*}, shape=sc}{0}

\def\mathbi#1{\textbf{\em #1}}

\usepackage{tikz}
\usetikzlibrary{arrows}
\usetikzlibrary{fit}
\usetikzlibrary{backgrounds}
\usetikzlibrary{positioning}

\renewcommand{\bibnumfmt}[1]{\scriptsize{#1}}

\usepackage{pgfplots} % for graphs
\usepgfplotslibrary{groupplots} %multiple plots
\usepgfplotslibrary{statistics} % for boxplots
\usepgfplotslibrary{ternary} %for ternary diagramq
\usetikzlibrary{plotmarks} %for tickmarks

\pgfplotsset{
    box plot/.style={
        /pgfplots/.cd,
        black,
        only marks,
        mark=-,
        mark size=\pgfkeysvalueof{/pgfplots/box plot width},
        /pgfplots/error bars/y dir=plus,
        /pgfplots/error bars/y explicit,
        /pgfplots/table/x index=\pgfkeysvalueof{/pgfplots/box plot x index},
    },
    box plot box/.style={
        /pgfplots/error bars/draw error bar/.code 2 args={%
            \draw  ##1 -- ++(\pgfkeysvalueof{/pgfplots/box plot width},0pt) |- ##2 -- ++(-\pgfkeysvalueof{/pgfplots/box plot width},0pt) |- ##1 -- cycle;
        },
        /pgfplots/table/.cd,
        y index=\pgfkeysvalueof{/pgfplots/box plot box top index},
        y error expr={
            \thisrowno{\pgfkeysvalueof{/pgfplots/box plot box bottom index}}
            - \thisrowno{\pgfkeysvalueof{/pgfplots/box plot box top index}}
        },
        /pgfplots/box plot
    },
    box plot top whisker/.style={
        /pgfplots/error bars/draw error bar/.code 2 args={%
            \pgfkeysgetvalue{/pgfplots/error bars/error mark}%
            {\pgfplotserrorbarsmark}%
            \pgfkeysgetvalue{/pgfplots/error bars/error mark options}%
            {\pgfplotserrorbarsmarkopts}%
            \path ##1 -- ##2;
        },
        /pgfplots/table/.cd,
        y index=\pgfkeysvalueof{/pgfplots/box plot whisker top index},
        y error expr={
            \thisrowno{\pgfkeysvalueof{/pgfplots/box plot box top index}}
            - \thisrowno{\pgfkeysvalueof{/pgfplots/box plot whisker top index}}
        },
        /pgfplots/box plot
    },
    box plot bottom whisker/.style={
        /pgfplots/error bars/draw error bar/.code 2 args={%
            \pgfkeysgetvalue{/pgfplots/error bars/error mark}%
            {\pgfplotserrorbarsmark}%
            \pgfkeysgetvalue{/pgfplots/error bars/error mark options}%
            {\pgfplotserrorbarsmarkopts}%
            \path ##1 -- ##2;
        },
        /pgfplots/table/.cd,
        y index=\pgfkeysvalueof{/pgfplots/box plot whisker bottom index},
        y error expr={
            \thisrowno{\pgfkeysvalueof{/pgfplots/box plot box bottom index}}
            - \thisrowno{\pgfkeysvalueof{/pgfplots/box plot whisker bottom index}}
        },
        /pgfplots/box plot
    },
    box plot median/.style={
        /pgfplots/box plot,
        /pgfplots/table/y index=\pgfkeysvalueof{/pgfplots/box plot median index}
    },
    box plot width/.initial=1em,
    box plot x index/.initial=0,
    box plot median index/.initial=1,
    box plot box top index/.initial=2,
    box plot box bottom index/.initial=3,
    box plot whisker top index/.initial=4,
    box plot whisker bottom index/.initial=5,
}

\pgfplotsset{
 tick label style={font=\small},
 label style={font=\small},
 legend style={font=\footnotesize}
}

\newcommand{\boxplot}[2][]{
    \addplot [box plot median,#1] table {#2};
    \addplot [forget plot, box plot box,#1] table {#2};
    \addplot [forget plot, box plot top whisker,#1] table {#2};
    \addplot [forget plot, box plot bottom whisker,#1] table {#2};
}

\usepackage{geometry}
\usepackage{pdflscape}

\renewcommand{\thefootnote}{\alph{footnote}}
\renewcommand*\footnoterule{}
\let\footnotesize\scriptsize