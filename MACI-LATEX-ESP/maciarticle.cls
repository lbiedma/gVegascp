%% This program is  free software; you can redistribute  it and/or modify
%% it under the  terms of the GNU General Public  License as published by
%% the Free Software Foundation; either  version 2 of the License, or (at
%% your option) any later version.

%% This program  is distributed in the  hope that it will  be useful, but
%% WITHOUT   ANY  WARRANTY;   without  even   the  implied   warranty  of
%% MERCHANTABILITY  or FITNESS  FOR A  PARTICULAR PURPOSE.   See  the GNU
%% General Public License for more details.

%% You  should have received  a copy  of the  GNU General  Public License
%% along  with  this  program;  if   not,  write  to  the  Free  Software
%% Foundation, Inc.,  59 Temple Place, Suite 330,  Boston, MA 02111-1307,
%% USA.

%% This is file `maci.cls', the class file for publications
%% of ASAMACI (Asociacion Argentina de Matematica Aplicada Computacional 
%% e Industrial).
%% http://asamaci.unsl.edu.ar/
%% This file is maintained by the ASAMACI Publication Style Committee:
%% Elina M. Mancinelli & Eduardo A. Santillan Marcus
%%
%%
%% For support contact see http://asamaci.unsl.edu.ar/
%% 
%% (originally written by Ton van den Boogaard for WCCM IV).
%% 
%% $Id texstuff-1.0.10-18-g74ee5ff Sat Apr 4 20:09:40 2009 -0300$
\NeedsTeXFormat{LaTeX2e}
\ProvidesClass{maciarticle}[2009/04/04 ASAMACI paper class]
%
\DeclareOption*{\PassOptionsToClass{\CurrentOption}{article}}
%
\def\macilanguage{0}
\DeclareOption{spanish}{\def\macilanguage{0}}
%
\def\macipagenumbers{0}
\DeclareOption{pagenumbers}{\def\macipagenumbers{1}}
%
\DeclareOption{english}{\def\macilanguage{1}}
%
\def\maciuselinks{0}
\DeclareOption{links}{\def\maciuselinks{1}}
\DeclareOption{nolinks}{\def\maciuselinks{0}}
%
\ProcessOptions\relax
%
\LoadClass[a4paper,11pt,twoside,onecolumn]{article}
%\LoadClass[a4paper,10pt,twoside,twocolumn]{article}
%
\RequirePackage{calc}
\RequirePackage{indentfirst}
%\RequirePackage[spanish,english]{babel}
%
\renewcommand{\@maketitle}{%
  {\begin{center}%
     {\LARGE \sc{\@title} \par}%
     \vskip 1em%
     {
        \lineskip .5em%
     \begin{tabular}[t]{c}%
        \@author
      \end{tabular}\par   
     }%
  \end{center}
  \vskip 2em
  }% end of \parbox
  } % end of \@maketitle


%\renewcommand{\abstractname}{abstract}
%\renewenvironment{abstract}{%
      %\noindent% 
%      \abstractname:%
%      \mdseries\small%
%}
%

\renewenvironment{abstract}{
        \noindent
        \abstractname: 
        \small
        }        
      

%
%
\newenvironment{keywords}{
  \vspace{2mm}
  \noindent
  \keywordsname: 
  \itshape\small
}
%


\newenvironment{mathsubclass}{
  \small
  \noindent
  \mathsubclassname: 
}

{\thispagestyle{empty}}


{\vspace{12pt}}
%
%
\renewcommand{\thesubsection}   {\textup{\thesection.\arabic{subsection}}}
\renewcommand{\thesubsubsection}{\textup{%
    \thesubsection .\arabic{subsubsection}}}
%
\renewcommand{\section}{\@startsection{section}{1}{0mm}%
                                     {-12pt}%
                                     {3pt}%
                                     {\bfseries\large\sc}}%
\renewcommand{\subsection}{\@startsection{subsection}{2}{0mm}%
                                     {-12pt}%
                                     {6pt}%
                                     {\bfseries\normalsize\sc}}%

\textwidth=165mm
\textheight=245mm
\oddsidemargin=-2.5mm
\evensidemargin=-2.5mm
\topmargin=-15mm
\addtolength{\columnsep}{3mm}


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
\setlength{\textfloatsep}{12pt}
\setlength{\abovedisplayskip}{6pt}
\setlength{\belowdisplayskip}{6pt}
\setlength{\parindent}{5mm}
\setlength{\abovecaptionskip}{6pt}
\setlength{\belowcaptionskip}{6pt}
%
% Previously in `instructions.tex'
%make-pdf
%\setlength{\affilsep}{0pt}
%
\renewcommand{\@makecaption}[2]{%
  \vspace{\abovecaptionskip}%
  {\fontsize{10}{12}\selectfont
  \sbox\@tempboxa{#1: #2}%
  \ifdim \wd\@tempboxa >\hsize
    #1: #2\par
  \else
    \global \@minipagefalse
    \hb@xt@\hsize{\hfil\box\@tempboxa\hfil}%
  \fi}
  \vskip\belowcaptionskip}
%
\def\voidaffil{$\mskip 0mu$}
%
\RequirePackage[noblocks]{authblk}
\renewcommand\Authands{ and }
\renewcommand{\Affilfont}{\mdseries\itshape\small}
%
\ifnum \macipagenumbers = 0
\pagestyle{empty}
\fi
%
\newcommand{\qed}{\hskip 10pt $\Box$}
%
%

%
%
\ifnum \macilanguage = 0
  \renewcommand\Authand{ y }%
  \renewcommand\Authands{ y }
  \RequirePackage[spanish]{babel}
  \def\keywordsname{Palabras clave}
  \def\mathsubclassname{2000 AMS Subject Classification}
  \def\bibliographyname{Referencias}
  \def\macibtxand{y}
  \addto\captionsspanish{%
  \def\tablename{Tabla}}%
  \newtheorem{theorem}{Teorema} 
  \newtheorem{lemma}{Lema}
  \newtheorem{proposition}{Proposición}
  \newtheorem{corollary}{Corolario}
  \newtheorem{definition}{Definición}
  \newtheorem{example}{Ejemplo}
  \newtheorem{note}{Nota}
  \newenvironment{proof}{\par \noindent{\it Prueba.\hskip 5pt}}{\hfill \qed \par}
\fi
%
\ifnum \macilanguage = 1
  \renewcommand\Authand{ and }%
  \renewcommand\Authands{ and }
  \RequirePackage[english]{babel}
  \def\keywordsname{Keywords}
  \def\mathsubclassname{2000 AMS Subject Classification}
  \def\bibliographyname{References}
  \def\macibtxand{and}
  \newtheorem{theorem}{Theorem}
  \newtheorem{lemma}{Lemma}
  \newtheorem{proposition}{Proposition}
  \newtheorem{corollary}{Corollary}
  \newtheorem{definition}{Definition}
  \newtheorem{example}{Example}
  \newtheorem{note}{Note}
  \newenvironment{proof}{\par \noindent{\it Proof.\hskip 5pt}}{\hfill \qed \par}
\fi
%
\ifnum \maciuselinks = 1
% Use color links
\RequirePackage{color}
\definecolor{url}{rgb}{0.8,0.,0.}
\RequirePackage[colorlinks,linkcolor=blue,%
                urlcolor=url,citecolor=blue,%
                plainpages=false,pdfpagelabels]{hyperref}
\RequirePackage{nameref,url}
\def\UrlFont{\mdseries}
\fi
%
\RequirePackage{times}
%
%\RequirePackage{fancyhdr}
%\pagestyle{fancyplain}
%
%\cfoot[]{}
%\lhead[\fancyplain{}{}]
%{\fancyplain{\scriptsize{}}{}}
%\rhead[\scriptsize{}]{}
%
%\renewcommand\headrulewidth{0.5pt}
%
%
\def\thebibliography#1{\section*{\bibliographyname}%
    \addcontentsline{toc}{section}{References}%
    \footnotesize \vskip 0.3\baselineskip plus 0.1\baselineskip minus 0.1\baselineskip%
    \list{\@biblabel{\@arabic\c@enumiv}}%
    {\settowidth\labelwidth{\@biblabel{#1}}%
    \leftmargin\labelwidth
    \advance\leftmargin\labelsep\relax
    \itemsep 0pt plus .5pt\relax%
    \usecounter{enumiv}%
    \let\p@enumiv\@empty
    \renewcommand\theenumiv{\@arabic\c@enumiv}}%
\def\newblock{\hskip .11em plus .33em minus .07em}%
\sloppy\clubpenalty4000\widowpenalty4000\interlinepenalty500%
    \sfcode`\.=1000\relax}
\let\endthebibliography=\endlist
%

