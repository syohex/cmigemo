# vim:set ts=8 sts=8 sw=8 tw=0:
#
# �����t�@�C���̃����e�i���X
# 
# Last Change: 16-May-2002.
# Written By:  MURAOKA Taro <koron@tka.att.ne.jp>

# �K�{�v���O����
# 	Perl, cURL, qkc, (cp, rm, mkdir)

DICT 		= migemo-dict
DICT_BASE	= base-dict
SKKDIC_BASEURL 	= http://openlab.ring.gr.jp/skk/dic
SKKDIC_FILE	= SKK-JISYO.L
EUCJP_DIR	= euc-jp.d

##############################################################################
# Dictionary
#
$(DICT): $(DICT_BASE)
	$(FILTER_CP932) < $(DICT_BASE) > $@
$(DICT_BASE): $(SKKDIC_FILE)
	$(PERL) ../tools/skk2migemo.pl < $(SKKDIC_FILE) > dict.tmp
	$(PERL) ../tools/optimize-dict.pl < dict.tmp > $@
	-$(RM) dict.tmp
$(SKKDIC_FILE):
	$(HTTP) $(SKKDIC_BASEURL)/$@.bz2
	$(BUNZIP2) $@.bz2

##############################################################################
# Dictionary in cp932
#
cp932:		$(DICT)

##############################################################################
# Dictionary in euc-jp
#
euc-jp: 	cp932 euc-jp-files
euc-jp-files: $(EUCJP_DIR) $(EUCJP_DIR)/migemo-dict $(EUCJP_DIR)/han2zen.dat \
		$(EUCJP_DIR)/hira2kata.dat $(EUCJP_DIR)/roma2hira.dat
$(EUCJP_DIR):
	$(MKDIR) $(EUCJP_DIR)
$(EUCJP_DIR)/migemo-dict: migemo-dict
	$(FILTER_EUCJP) < $< > $@
$(EUCJP_DIR)/han2zen.dat: han2zen.dat
	$(FILTER_EUCJP) < $< > $@
$(EUCJP_DIR)/hira2kata.dat: hira2kata.dat
	$(FILTER_EUCJP) < $< > $@
$(EUCJP_DIR)/roma2hira.dat: roma2hira.dat
	$(FILTER_EUCJP) < $< > $@

##############################################################################
# for Microsoft Visual C
#
msvc:		cp932

##############################################################################
# for Borland C 5
#
bc5:		cp932

##############################################################################
# for Cygwin
#
cyg:		euc-jp

##############################################################################
# for MacOS X
#
osx:		euc-jp

##############################################################################
# for Linux
#
linux:		euc-jp

##############################################################################
# Cleaning
#
dict-clean:
	-$(RM) $(DICT)
	-$(RMDIR) $(EUCJP_DIR)
dict-distclean: dict-clean
	-$(RM) $(DICT_BASE)
	-$(RM) SKK-JISYO*