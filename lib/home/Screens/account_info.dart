import 'package:flutter/material.dart';
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

// StockInfo 클래스 정의
class StockInfo {
  final String pdno;
  final String prdtName;
  final String tradDvsnName;
  final int hldgQty;
  final int ordPsblQty;
  final double pchsAvgPric;
  final double pchsAmt;
  final double prpr;
  final double evluAmt;
  final double evluPflsAmt;
  final double evluPflsRt;
  final double flttRt;

  StockInfo({
    required this.pdno,
    required this.prdtName,
    required this.tradDvsnName,
    required this.hldgQty,
    required this.ordPsblQty,
    required this.pchsAvgPric,
    required this.pchsAmt,
    required this.prpr,
    required this.evluAmt,
    required this.evluPflsAmt,
    required this.evluPflsRt,
    required this.flttRt,
  });

  factory StockInfo.fromJson(Map<String, dynamic> json) {
    return StockInfo(
      pdno: json['pdno'],
      prdtName: json['prdt_name'],
      tradDvsnName: json['trad_dvsn_name'],
      hldgQty: json['hldg_qty'],
      ordPsblQty: json['ord_psbl_qty'],
      pchsAvgPric: json['pchs_avg_pric'],
      pchsAmt: json['pchs_amt'],
      prpr: json['prpr'],
      evluAmt: json['evlu_amt'],
      evluPflsAmt: json['evlu_pfls_amt'],
      evluPflsRt: json['evlu_pfls_rt'],
      flttRt: json['fltt_rt'],
    );
  }
}
