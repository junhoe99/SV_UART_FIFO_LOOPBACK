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
### **2. DUT System Block Diagram**
![System Block](https://github.com/user-attachments/assets/f42e7085-e6bc-44c7-9b80-bd48747d063a)

---

### **3. Protocol**

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
![TB Architecture](https://github.com/user-attachments/assets/941bc3b9-728d-4a0c-8083-82cdb666bb6d)


## 📋 Testcase & Scenario
```markdown
  ├── 🗂️ 1. Basic Cases
  │    ├── 📂 1.1 Reset Test
  │    └── 📂 1.2 Single Byte Loopback
  │  
  └── 🗂️ 2. Functional Cases  
       ├── 📂2.1 Sequential Data Flow
       └── 📂2.2 Random Data Flow
 ```

## ✨ Verification Results

### 🔹 1. Basic Cases

#### 1.1 Reset Test
<table>
<tr>
<td width="70%">
  
**목적**: DUT Reset 동작 시, 내부 FIFO 및 TX/RX 상태가 초기화되는지 확인  
**결과**: 정상적으로 모든 레지스터가 초기화되고, 출력 신호가 idle 상태로 복귀함  
    
**Log 요약**:
```text
[INFO] Reset asserted at 100ns
[INFO] FIFO empty: PASS
[INFO] TX idle: PASS
</td> <td width="40%">
```

**Waveform**:
<img src="./docs/waveform/reset_test.png" width="350">

</td> </tr> </table>


#### 1.2 Single Byte Loopback
<table>
<tr>
<td width="60%">

**목적**: 단일 바이트가 FIFO를 거쳐 UART Loopback을 통해 동일하게 출력되는지 검증
**결과**: 입력 0xA5 → 출력 0xA5 확인

**Log 요약**:
```text
[INFO] TX Data: 0xA5
[INFO] RX Data: 0xA5
[PASS] Single Byte Loopback Test
```

**Waveform**:
<img src="./docs/waveform/reset_test.png" width="350">
  
</td> </tr> </table>

### 🔹 2. Functional Cases

#### 2.1 Sequential Data Flow
- **목적**: 연속된 데이터 스트림이 손실 없이 전송/수신되는지 검증
- **결과**: 입력 시퀀스 0x01 ~ 0x05 → 출력 동일하게 수신됨
- **Waveform**:  
  ![Reset Test Waveform](./docs/waveform/reset_test.png)  
- **Log 요약**:
```text
[INFO] TX: 0x01, RX: 0x01
[INFO] TX: 0x02, RX: 0x02
...
[PASS] Sequential Data Flow Test
```

#### 2.2 Random Data Flow
- **목적**: 랜덤 데이터 스트림에서 데이터 무결성 검증 및 FIFO Overflow/Underflow 여부 확인
- **결과**: 1000개의 랜덤 데이터 모두 무결하게 전달됨, Overflow/Underflow 미발생
- **Waveform**:  
  ![Reset Test Waveform](./docs/waveform/reset_test.png)  
- **Log 요약**:
```text
[INFO] Random test started (seed=42)
[INFO] Total TX=1000, RX=1000, Error=0
[PASS] Random Data Flow Test
```

## 🔥 Insights
--------------------------
