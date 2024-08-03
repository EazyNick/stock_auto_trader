import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'dart:convert';

// AccountInfo 클래스 정의
class AccountInfo {
  final int dncaTotAmt;
  final int nxdyExccAmt;
  final int prvsRcdlExccAmt;
  final int sctsEvluAmt;
  final int totEvluAmt;
  final int nassAmt;
  final int pchsAmtSmtlAmt;
  final int evluAmtSmtlAmt;
  final int evluPflsSmtlAmt;
  final int bfdyTotAsstEvluAmt;
  final int asstIcdcAmt;
  final int asstIcdcErngRt;

  AccountInfo({
    required this.dncaTotAmt,
    required this.nxdyExccAmt,
    required this.prvsRcdlExccAmt,
    required this.sctsEvluAmt,
    required this.totEvluAmt,
    required this.nassAmt,
    required this.pchsAmtSmtlAmt,
    required this.evluAmtSmtlAmt,
    required this.evluPflsSmtlAmt,
    required this.bfdyTotAsstEvluAmt,
    required this.asstIcdcAmt,
    required this.asstIcdcErngRt,
  });

  // JSON 데이터를 AccountInfo 객체로 변환하는 메서드
  factory AccountInfo.fromJson(Map<String, dynamic> json) {
    return AccountInfo(
      dncaTotAmt: json['dnca_tot_amt'],
      nxdyExccAmt: json['nxdy_excc_amt'],
      prvsRcdlExccAmt: json['prvs_rcdl_excc_amt'],
      sctsEvluAmt: json['scts_evlu_amt'],
      totEvluAmt: json['tot_evlu_amt'],
      nassAmt: json['nass_amt'],
      pchsAmtSmtlAmt: json['pchs_amt_smtl_amt'],
      evluAmtSmtlAmt: json['evlu_amt_smtl_amt'],
      evluPflsSmtlAmt: json['evlu_pfls_smtl_amt'],
      bfdyTotAsstEvluAmt: json['bfdy_tot_asst_evlu_amt'],
      asstIcdcAmt: json['asst_icdc_amt'],
      asstIcdcErngRt: json['asst_icdc_erng_rt'],
    );
  }
}



