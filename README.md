# SV_UART_FIFO_LOOPBACK

----
# 🌐[SystemVerilog Based UART_FIFO_LOOPBACK]

> 이 프로젝트는 UART_FIFO 모듈을 System Verilog 기반 TB 환경에서 검증하는 프로젝트입니다.


## 🔎 Overview
본 프로젝트는 UART_RX, UART_TX, FIFO 모듈을 포함하는 UART_TOP 모듈에 대해 SystemVerilog를 기반으로 Testbench Architecture를 구성하고, report & waveform을 통해 동작 검증을 수행합니다.

---

## 📌 DUT Spec Analysis

### **1. Key Parameters / Features**
- **Data Bits** : 8bit  
- **Parity Bits** : 없음 → 단순성과 리소스 절약을 위해 parity bit 미사용
- **BAUD Rate** : 9600 bps
- **Oversampling Rate** : 16  
  UART는 비동기 통신이므로 TX/RX 클럭이 완벽히 맞지 않아도 동작해야 함 → **16배 Oversampling**으로 타이밍 동기화 & 정확한 데이터 샘플링 구현
---
### **2. System Block Diagram**
![System Block](https://github.com/user-attachments/assets/f42e7085-e6bc-44c7-9b80-bd48747d063a)

---

### **3. Protocol**
![Protocol](https://github.com/user-attachments/assets/0bf95832-7a3f-4a1a-8e93-271f4bd011b7)

#### **필수 Protocol 규칙(ASSERTION & COVERAGE로 검증할 예정)**
| 규칙 | 설명 |
|------|------|
| **START BIT** | 각 전송 frame은 반드시 **start bit = 0**으로 시작해야 함 |
| **STOP BIT**  | 전송 종료 시 반드시 **stop bit = 1**로 끝나야 함 |
| **BIT SEQUENCE** | 데이터 bit는 **LSB → MSB** 순서로 전송 |
| **BIT WIDTH PER CLK** | 각 비트의 duration은 **baud rate**에 맞춰야 함 |

---


## 🔁 Verification Plan

## 📚 TB Architecture
![System Block](https://github.com/user-attachments/assets/941bc3b9-728d-4a0c-8083-82cdb666bb6d)


## 📋 Testcase & Scenario
  
  ├── 🗂️ 1. Basic Cases
  │ ├── 📂 1.1 Reset Test
  │ └── 📂 1.2 Single Byte Loopback
  │  
  └── 🗂️ 2. Functional Cases  
       ├── 📂2.1 Sequential Data Flow
       └── 📂2.2 Random Data Flow
       

## ✨ Verification Results

## 🔥 Insights
--------------------------
