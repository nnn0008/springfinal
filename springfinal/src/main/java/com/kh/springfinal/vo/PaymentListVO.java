package com.kh.springfinal.vo;

import java.util.List;

import com.kh.spring21.dto.PaymentDetailDto;
import com.kh.springfinal.dto.PaymentDto;

import lombok.Data;

@Data
public class PaymentListVO {
	private PaymentDto paymentDto;
	private List<PaymentDetailDto> paymentDetailList;
}
