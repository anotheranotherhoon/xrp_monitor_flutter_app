#!/bin/bash

# XRP Monitor Flutter App Test Runner
# 이 스크립트는 다양한 타입의 테스트를 실행합니다.

echo "🧪 XRP Monitor 테스트 실행기"
echo "=================================="

# 색상 정의
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m' # No Color

# 테스트 타입 확인
if [ "$1" = "unit" ]; then
    echo -e "${YELLOW}📝 유닛 테스트 실행 중...${NC}"
    fvm flutter test test/unit/
    
elif [ "$1" = "widget" ]; then
    echo -e "${YELLOW}🎯 위젯 테스트 실행 중...${NC}"
    fvm flutter test test/widget/
    
elif [ "$1" = "integration" ]; then
    echo -e "${YELLOW}🔗 통합 테스트 실행 중...${NC}"
    echo "통합 테스트는 실제 디바이스나 에뮬레이터가 필요합니다."
    read -p "계속하시겠습니까? (y/N): " -n 1 -r
    echo
    if [[ $REPLY =~ ^[Yy]$ ]]; then
        fvm flutter test integration_test/app_test.dart
    else
        echo "통합 테스트가 취소되었습니다."
        exit 0
    fi
    
elif [ "$1" = "all" ]; then
    echo -e "${YELLOW}🎯 모든 테스트 실행 중...${NC}"
    
    echo -e "${GREEN}1. 유닛 테스트${NC}"
    fvm flutter test test/unit/
    
    echo -e "${GREEN}2. 위젯 테스트${NC}"
    fvm flutter test test/widget/
    
    echo -e "${YELLOW}통합 테스트는 별도로 실행해주세요: ./test_runner.sh integration${NC}"
    
elif [ "$1" = "coverage" ]; then
    echo -e "${YELLOW}📊 테스트 커버리지 생성 중...${NC}"
    fvm flutter test --coverage
    
    if command -v lcov &> /dev/null; then
        echo -e "${GREEN}HTML 커버리지 리포트 생성 중...${NC}"
        genhtml coverage/lcov.info -o coverage/html
        echo -e "${GREEN}커버리지 리포트가 coverage/html/index.html에 생성되었습니다.${NC}"
    else
        echo -e "${YELLOW}lcov가 설치되지 않았습니다. HTML 리포트를 생성하려면 lcov를 설치해주세요.${NC}"
        echo "macOS: brew install lcov"
        echo "Ubuntu: sudo apt-get install lcov"
    fi
    
else
    echo "사용법: ./test_runner.sh [unit|widget|integration|all|coverage]"
    echo ""
    echo "옵션:"
    echo "  unit        - 유닛 테스트만 실행"
    echo "  widget      - 위젯 테스트만 실행"
    echo "  integration - 통합 테스트 실행 (디바이스/에뮬레이터 필요)"
    echo "  all         - 유닛 + 위젯 테스트 실행"
    echo "  coverage    - 테스트 커버리지 생성"
    echo ""
    echo "예시:"
    echo "  ./test_runner.sh unit"
    echo "  ./test_runner.sh all"
    echo "  ./test_runner.sh coverage"
    exit 1
fi

echo -e "${GREEN}✅ 테스트 완료!${NC}"